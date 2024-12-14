.include "../assets/nametable01.s"
.include "../assets/nametable02.s"
.include "random-generator.s"


.segment "ZEROPAGE"
ptrPreviousDrawnNametable: .res 2 ; Old poiner
ptrActiveDrawnNameTable: .res 2 ; Current nameable drawn pointer

NameTablePtrs:
lowPipesPtr: .res 2
nametable01Ptr: .res 2
nametable02Ptr: .res 2
pipesPtr: .res 2

.segment "CODE"
.define NAMETABLECOUNT 4 ; 

.proc InitNameTableSelector
  lda #<lowPipes
  sta lowPipesPtr
  lda #>lowPipes
  sta lowPipesPtr+1

  lda #<nametable01
  sta nametable01Ptr
  lda #>nametable01
  sta nametable01Ptr+1

  lda #<nametable02
  sta nametable02Ptr
  lda #>nametable02
  sta nametable02Ptr+1

  lda #<pipes
  sta pipesPtr
  lda #>pipes
  sta pipesPtr+1

  lda #<startScreen
  sta ptrPreviousDrawnNametable
  lda #>startScreen
  sta ptrPreviousDrawnNametable+1


  ; Will be overwritten at first frame but lets not have it point to random stuff
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

