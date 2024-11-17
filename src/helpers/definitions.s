PPU_CTRL = $2000
; TODO: Better explaintion
; VPHB SINN
; |||| ||||
; |||| ||++- Base nametable address
; |||| ||    (0 = $2000; 1 = $2400; 2 = $2800; 3 = $2C00)
; |||| |+--- VRAM address increment per CPU read/write of PPUDATA
; |||| |     (0: add 1, going across; 1: add 32, going down)
; |||| +---- Sprite pattern table address for 8x8 sprites
; ||||       (0: $0000; 1: $1000; ignored in 8x16 mode)
; |||+------ Background pattern table address (0: $0000; 1: $1000)
; ||+------- Sprite size (0: 8x8 pixels; 1: 8x16 pixels – see PPU OAM#Byte 1)
; |+-------- PPU master/slave select
; |          (0: read backdrop from EXT pins; 1: output color on EXT pins)
; +--------- Vblank NMI enable (0: off, 1: on)

PPU_MASK = $2001 
; Write only
; BGRs bMmG
; TODO EXPLAIN

PPU_STATUS = $2002
; Read only
; VSO- ----
; TODO EXPLAIN

OAM_ADDR = $2003
; Write only 
; Adress in OAM
; TODO EXPLAIN

OAM_DATA = $2004
; Read/Write
; Write data to OAM
; TODO EXPLAIN

PPU_SCROLL = $2005
; Write 2 times. First X then Y
; Set the scroll value of the background.
; TODO EXPLAIN

PPU_ADDR = $2006
; Write 2 times. First upper then lower,
; Sets the adress of the ppu pointer on where to write in vram.
; TODO EXPLAIN 

PPU_DATA = $2007
; Read/Write. 
; Write data where the PPU_ADDR is pointing to. Then PPU_ADDR pointer increments by 1.



OAM_DMA = $4014 
; Write
; No clue what this does
; TODO EXPLAIN



JOYPAD1		= $4016
JOYPAD2		= $4017
; Location of the 2 controllers



; PPU_CTRL flags
CTRL_NMI	= %10000000	; Execute Non-Maskable Interrupt on VBlank
CTRL_8x8	= %00000000 	; Use 8x8 Sprites
CTRL_8x16	= %00100000 	; Use 8x16 Sprites
CTRL_BG_0000	= %00000000 	; Background Pattern Table at $0000 in VRAM
CTRL_BG_1000	= %00010000 	; Background Pattern Table at $1000 in VRAM
CTRL_SPR_0000	= %00000000 	; Sprite Pattern Table at $0000 in VRAM
CTRL_SPR_1000	= %00001000 	; Sprite Pattern Table at $1000 in VRAM
CTRL_INC_1	= %00000000 	; Increment PPU Address by 1 (Horizontal rendering)
CTRL_INC_32	= %00000100 	; Increment PPU Address by 32 (Vertical rendering)
CTRL_NT_2000	= %00000000 	; Name Table Address at $2000
CTRL_NT_2400	= %00000001 	; Name Table Address at $2400
CTRL_NT_2800	= %00000010 	; Name Table Address at $2800
CTRL_NT_2C00	= %00000011 	; Name Table Address at $2C00


; PPU_MASK flags
MASK_TINT_RED	= %00100000	; Red Background
MASK_TINT_BLUE	= %01000000	; Blue Background
MASK_TINT_GREEN	= %10000000	; Green Background
MASK_SPR	= %00010000 	; Sprites Visible
MASK_BG		= %00001000 	; Backgrounds Visible
MASK_SPR_CLIP	= %00000100 	; Sprites clipped on left column
MASK_BG_CLIP	= %00000010 	; Background clipped on left column
MASK_COLOR	= %00000000 	; Display in Color
MASK_MONO	= %00000001 	; Display in Monochrome



; APU
PPU_OAM_DMA	= $4014
DMC_FREQ	= $4010
APU_STATUS	= $4015
APU_NOISE_VOL   = $400C
APU_NOISE_FREQ  = $400E
APU_NOISE_TIMER = $400F
APU_DMC_CTRL    = $4010
APU_CHAN_CTRL   = $4015
APU_FRAME       = $4017