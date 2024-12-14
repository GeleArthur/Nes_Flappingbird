.include "../assets/nametable01.s"
.include "../assets/nametable02.s"


.segment "ZEROPAGE"
ptrToCurrentNametable1: .res 2
ptrToCurrentNametable2: .res 2

NameTablePtrs:
lowPipesPtr: .res 2
nametable01Ptr: .res 2
nametable02Ptr: .res 2
pipesPtr: .res 2

.segment "CODE"
.define NAMETABLECOUNT 4

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
  sta ptrToCurrentNametable1
  lda #>startScreen
  sta ptrToCurrentNametable1+1


  ; Will be overwritten at first frame but lets not have it point to random stuff
  lda #<lowPipes
  sta ptrToCurrentNametable2
  lda #>lowPipes
  sta ptrToCurrentNametable2+1

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
  
  lda ptrToCurrentNametable2
  sta ptrToCurrentNametable1

  lda ptrToCurrentNametable2+1
  sta ptrToCurrentNametable1+1

  


NTSwapCheckDone:

  rts
.endproc

