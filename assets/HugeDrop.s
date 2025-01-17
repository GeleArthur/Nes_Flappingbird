.segment "RODATA"

HugeDrop:

HugeDropCloseCollision:
    .byte 2*8 - 4, 10*8 + 4
    .byte 6*8 - 4, 16*8 + 4
    .byte 6*8 - 4, 14*8 + 4
    .byte 10*8 - 4, 18*8 + 4
	
HugeDropAttributeTable:	
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$33,$cc,$30,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$f0,$00,$00,$00,$00,$00,$00,$0c,$0f,$03,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $a0,$a0,$a0,$a0,$aa,$a0,$a0,$a0,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a

HugeDropNameTable:
	.byte $00,$00,$00,$00,$05,$06,$07,$08,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$09,$0a,$0b,$0c,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$06,$07,$08
	.byte $00,$00,$00,$00,$05,$06,$07,$08,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$b0,$b7,$00,$00,$00,$00,$00,$b0,$09,$0a,$0b,$0c
	.byte $00,$00,$00,$00,$09,$0a,$0b,$0c,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$b1,$c8,$00,$00,$00,$00,$00,$b1,$c8,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$06,$07,$08
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$09,$0a,$0b,$0c
	.byte $00,$00,$00,$00,$05,$06,$07,$08,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$b0,$b3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$09,$0a,$0b,$0c,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $b2,$01,$01,$b7,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$00,$00,$00,$b0
	.byte $01,$01,$01,$01,$c7,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$00,$00,$00,$b1
	.byte $b4,$b5,$c6,$b5,$b6,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$05,$06,$07,$08,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$09,$0a,$0b,$0c,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$05,$06,$07,$08
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$09,$0a,$0b,$0c
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$05,$06,$07,$08
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$09,$0a,$0b,$0c
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $00,$00,$00,$00,$0d,$0e,$0f,$10,$00,$b2,$b3,$00,$0d,$0e,$0f,$10
	.byte $00,$23,$23,$00,$0d,$0e,$0f,$10,$00,$00,$00,$00,$0d,$0e,$0f,$10
	.byte $b2,$b7,$00,$00,$0d,$0e,$0f,$10,$b0,$01,$01,$b7,$0d,$0e,$0f,$10
	.byte $00,$22,$22,$00,$0d,$0e,$0f,$10,$00,$00,$b0,$b7,$0d,$0e,$0f,$10
	.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	.byte $21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21
	.byte $21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21
	.byte $21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21
	.byte $21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21
	.byte $21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21
	.byte $21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21

