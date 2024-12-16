.include "../assets/HugeDrop.s"
.include "../assets/BottomWide.s"
.include "../assets/LowPipes.s"
.include "../assets/WideToClose.s"
.include "../assets/UpAndDown.s"
.include "random-generator.s"


.segment "ZEROPAGE"
ptrPreviousDrawnNametable: .res 2 ; Old poiner
ptrActiveDrawnNameTable: .res 2 ; Current nameable drawn pointer

NameTablePtrs:
lowPipesPtr: .res 2
WideToClosePtr: .res 2
HugeDropPtr: .res 2
BottomWidePtr: .res 2

.segment "CODE"
.define NAMETABLECOUNT 4 ; 

.proc InitNameTableSelector
  lda #<UpAndDown
  sta lowPipesPtr
  lda #>UpAndDown
  sta lowPipesPtr+1

  lda #<WideToClose
  sta WideToClosePtr
  lda #>WideToClose
  sta WideToClosePtr+1

  lda #<HugeDrop
  sta HugeDropPtr
  lda #>HugeDrop
  sta HugeDropPtr+1

  lda #<BottomWide
  sta BottomWidePtr
  lda #>BottomWide
  sta BottomWidePtr+1

  lda #<startScreen
  sta ptrPreviousDrawnNametable
  lda #>startScreen
  sta ptrPreviousDrawnNametable+1


  lda #<lowPipes
  sta ptrActiveDrawnNameTable
  lda #>lowPipes
  sta ptrActiveDrawnNameTable+1

  rts
.endproc

.proc ScrollBackground
  inc scroll_pos

  lda scroll_pos       ; check if the scroll just wrapped from 255 to 0
  bne NTSwapCheckDone
  
  lda flippingScroll    ; load current nametable number (0 or 1)
  eor #$01              ; exclusive OR of bit 0 will flip that bit
  sta flippingScroll    ; so if nametable was 0, now 1
                        ;    if nametable was 1, now 0
  
  ; Copy over prevous table
  lda ptrActiveDrawnNameTable
  sta ptrPreviousDrawnNametable

  lda ptrActiveDrawnNameTable+1
  sta ptrPreviousDrawnNametable+1

  jsr prng
  lsr
  lsr
  lsr
  lsr
  lsr 
  lsr ; Get a random number between 0-4
  asl ; *2 of stride offset

  clc
  adc #<NameTablePtrs ; Add where the nametables pointers start. 


  tax
  lda $00, x
  sta ptrActiveDrawnNameTable
  inx
  lda $00, x
  sta ptrActiveDrawnNameTable+1

NTSwapCheckDone:

  rts
.endproc

