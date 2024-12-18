; This file is for the FamiStudio Sound Engine and was generated by FamiStudio

.if FAMISTUDIO_CFG_C_BINDINGS
.export _music_data_floppy_birds=music_data_floppy_birds
.endif

music_data_floppy_birds:
	.byte 2
	.word @instruments
	.word @samples-4
; 00 : Impending Doom
	.word @song0ch0
	.word @song0ch1
	.word @song0ch2
	.word @song0ch3
	.word @song0ch4
	.byte .lobyte(@tempo_env_1_mid), .hibyte(@tempo_env_1_mid), 0, 0
; 01 : The Pipes Keep Comming
	.word @song1ch0
	.word @song1ch1
	.word @song1ch2
	.word @song1ch3
	.word @song1ch4
	.byte .lobyte(@tempo_env_1_mid), .hibyte(@tempo_env_1_mid), 0, 0

.export music_data_floppy_birds
.global FAMISTUDIO_DPCM_PTR

@instruments:
	.word @env4,@env23,@env19,@env0 ; 00 : NoiseSnare
	.word @env8,@env14,@env19,@env0 ; 01 : NoiseBassDrum
	.word @env11,@env14,@env19,@env5 ; 02 : TriSnare
	.word @env31,@env14,@env19,@env1 ; 03 : TriBassDrum
	.word @env18,@env27,@env19,@env0 ; 04 : OH(F#3)
	.word @env32,@env14,@env19,@env0 ; 05 : snare attack(D3)
	.word @env33,@env28,@env19,@env0 ; 06 : kick attack(E3)
	.word @env16,@env14,@env24,@env13 ; 07 : SquareHit
	.word @env15,@env14,@env21,@env0 ; 08 : SquareLeadLow
	.word @env30,@env14,@env21,@env10 ; 09 : SquareLeadHigh
	.word @env17,@env14,@env24,@env0 ; 0a : SquareBridgePlain
	.word @env16,@env14,@env25,@env2 ; 0b : SquareBridgeArpeggio
	.word @env29,@env6,@env19,@env0 ; 0c : crash(F#3)
	.word @env7,@env14,@env26,@env0 ; 0d : SquareIntroArpeggio
	.word @env12,@env14,@env21,@env0 ; 0e : SquareBridgeHit
	.word @env9,@env14,@env22,@env0 ; 0f : Lead 25 25 12.5
	.word @env9,@env14,@env34,@env0 ; 10 : Lead 50 50 25
	.word @env11,@env35,@env19,@env0 ; 11 : Tribass sub
	.word @env3,@env14,@env25,@env0 ; 12 : SquareChorusArpeggio

@env0:
	.byte $00,$c0,$7f,$00,$02
@env1:
	.byte $80,$fc,$00,$01
@env2:
	.byte $00,$c0,$09,$bf,$bf,$c0,$c0,$c1,$c1,$c0,$c0,$00,$03
@env3:
	.byte $06,$c6,$02,$c5,$00,$03,$c4,$c3,$c2,$c1,$00,$09
@env4:
	.byte $00,$cd,$cb,$c9,$c7,$c5,$c3,$c1,$c0,$00,$08
@env5:
	.byte $80,$e0,$00,$01
@env6:
	.byte $c0,$c0,$c2,$00,$02
@env7:
	.byte $00,$c9,$c6,$c4,$c1,$00,$03
@env8:
	.byte $00,$cd,$c0,$00,$02
@env9:
	.byte $06,$cd,$ca,$c9,$00,$03,$c1,$00,$06
@env10:
	.byte $00,$c0,$0f,$c1,$c1,$c0,$c0,$bf,$bf,$c0,$c0,$00,$03
@env11:
	.byte $00,$cf,$7f,$00,$02
@env12:
	.byte $0b,$cf,$cd,$cd,$cb,$02,$ca,$02,$c9,$00,$08,$c1,$c9,$c6,$c5,$c4,$c2,$00,$10
@env13:
	.byte $00,$c0,$c0,$c1,$c1,$c0,$c0,$bf,$bf,$00,$01
@env14:
	.byte $c0,$7f,$00,$01
@env15:
	.byte $04,$c4,$00,$01,$c3,$c2,$c1,$00,$06
@env16:
	.byte $11,$c9,$cd,$cc,$cb,$0e,$ca,$0e,$c9,$0c,$c8,$0c,$c7,$0f,$c6,$00,$0e,$c1,$c5,$c4,$c3,$c2,$c1,$00,$16
@env17:
	.byte $00,$c4,$7f,$00,$02
@env18:
	.byte $00,$c9,$03,$c7,$c0,$00,$04
@env19:
	.byte $7f,$00,$00
@env20:
	.byte $00,$c0,$bc,$ba,$bc,$c0,$c4,$c6,$c4,$00,$01
@env21:
	.byte $c2,$7f,$00,$00
@env22:
	.byte $c1,$c1,$c0,$00,$02
@env23:
	.byte $b9,$c0,$00,$01
@env24:
	.byte $c1,$7f,$00,$00
@env25:
	.byte $c0,$c1,$00,$01
@env26:
	.byte $c2,$c0,$c0,$00,$00
@env27:
	.byte $c0,$c2,$00,$01
@env28:
	.byte $c0,$c4,$00,$01
@env29:
	.byte $00,$ca,$02,$c9,$03,$c8,$03,$c7,$03,$c6,$03,$c5,$03,$c4,$03,$c3,$03,$c2,$03,$c1,$00,$13
@env30:
	.byte $09,$cf,$cd,$cd,$ca,$04,$c9,$00,$06,$c8,$03,$c7,$03,$c6,$03,$c5,$03,$c4,$03,$c3,$03,$c2,$03,$c1,$00,$17
@env31:
	.byte $00,$cf,$03,$c0,$00,$03
@env32:
	.byte $00,$cd,$c7,$c6,$c5,$c5,$c4,$03,$c3,$00,$08
@env33:
	.byte $00,$c5,$c3,$c2,$c1,$c0,$00,$05
@env34:
	.byte $c2,$c2,$c1,$00,$02
@env35:
	.byte $cc,$c0,$00,$01

@samples:
	.byte $6c+.lobyte(FAMISTUDIO_DPCM_PTR),$60,$0d,$40 ; 00 GimmickBass0A (Pitch:13)
	.byte $6c+.lobyte(FAMISTUDIO_DPCM_PTR),$60,$0e,$40 ; 01 GimmickBass0A (Pitch:14)
	.byte $98+.lobyte(FAMISTUDIO_DPCM_PTR),$60,$0d,$40 ; 02 GimmickBass0B (Pitch:13)
	.byte $54+.lobyte(FAMISTUDIO_DPCM_PTR),$60,$0d,$40 ; 03 GimmickBass0C (Pitch:13)
	.byte $54+.lobyte(FAMISTUDIO_DPCM_PTR),$60,$0e,$40 ; 04 GimmickBass0C (Pitch:14)
	.byte $54+.lobyte(FAMISTUDIO_DPCM_PTR),$60,$0f,$40 ; 05 GimmickBass0C (Pitch:15)
	.byte $b0+.lobyte(FAMISTUDIO_DPCM_PTR),$60,$0e,$40 ; 06 GimmickBass0C# (Pitch:14)
	.byte $30+.lobyte(FAMISTUDIO_DPCM_PTR),$60,$0e,$40 ; 07 GimmickBass0D (Pitch:14)
	.byte $30+.lobyte(FAMISTUDIO_DPCM_PTR),$60,$0f,$40 ; 08 GimmickBass0D (Pitch:15)
	.byte $84+.lobyte(FAMISTUDIO_DPCM_PTR),$50,$0f,$40 ; 09 GimmickBass0D# (Pitch:15)
	.byte $c8+.lobyte(FAMISTUDIO_DPCM_PTR),$50,$0f,$40 ; 0a GimmickBass0E (Pitch:15)
	.byte $dc+.lobyte(FAMISTUDIO_DPCM_PTR),$50,$0f,$40 ; 0b GimmickBass0F (Pitch:15)
	.byte $f0+.lobyte(FAMISTUDIO_DPCM_PTR),$40,$0e,$40 ; 0c GimmickBass1C (Pitch:14)
	.byte $48+.lobyte(FAMISTUDIO_DPCM_PTR),$30,$0f,$00 ; 0d GimmickSnare (Pitch:15)
	.byte $20+.lobyte(FAMISTUDIO_DPCM_PTR),$3f,$0a,$40 ; 0e SiliusBassB (Pitch:10)
	.byte $10+.lobyte(FAMISTUDIO_DPCM_PTR),$3f,$09,$40 ; 0f SiliusBassC (Pitch:9)
	.byte $10+.lobyte(FAMISTUDIO_DPCM_PTR),$3f,$0a,$40 ; 10 SiliusBassC (Pitch:10)
	.byte $00+.lobyte(FAMISTUDIO_DPCM_PTR),$3f,$07,$40 ; 11 SiliusBassD (Pitch:7)
	.byte $00+.lobyte(FAMISTUDIO_DPCM_PTR),$3f,$08,$40 ; 12 SiliusBassD (Pitch:8)

@tempo_env_1_mid:
	.byte $03,$05,$80

@song0ch0:
	.byte $9f, $90, $1b, $ff, $f5, $48, $9f, $1d, $ff, $f5, $48, $9f, $1e, $ff, $89, $1f, $e9, $48, $9f, $20, $ff, $f5
@song0ch0loop:
	.byte $47, .lobyte(@tempo_env_1_mid), .hibyte(@tempo_env_1_mid), $00, $e3
@song0ref29:
	.byte $90, $22, $8f, $25, $8d, $29, $8f, $27, $9b, $45, $83, $25, $9b, $45, $81, $24, $9b, $45, $83, $25, $91, $48, $89, $45
	.byte $81, $22, $9b, $45, $a9, $00, $ff, $97, $1d, $8f, $1e, $8d, $20, $81, $48, $ad, $45, $81, $1d, $8d, $19, $9d, $45, $ad
	.byte $00, $dd, $1b, $8f, $20, $8d, $25, $81, $48, $8d, $24, $9b, $45, $83, $22, $9b, $45, $a9, $00, $e5, $8e, $27, $8b, $45
	.byte $8b, $00, $85, $29, $85, $45, $85, $48, $89, $00, $d9
	.byte $41, $12
	.word @song0ref29
	.byte $2c, $91, $48, $89, $45, $81, $29, $9b, $45, $a9, $00, $ff, $97, $29, $8f, $27, $8d, $25, $81, $48, $8d, $24, $9b, $45
	.byte $83, $25, $8d, $22, $9d, $45, $ad, $00, $dd, $29, $8f, $27, $8d, $25, $81, $48, $8d, $2c, $9b, $45, $cd, $00, $8d, $8e
	.byte $2c, $87, $45, $85, $2c, $87, $45, $8d, $00, $dd, $48, $91, $7a, $90
@song0ref177:
	.byte $16, $85, $19, $87, $20, $85, $22, $87, $25, $83, $2a, $87, $2e, $87, $31, $85, $36, $85, $31, $87, $2e, $85, $2a, $87
	.byte $25, $83, $22, $87, $1e, $87, $19, $85, $18, $85, $1b, $87, $20, $85, $24, $87, $27, $83, $2c, $87, $30, $87, $33, $85
	.byte $38, $85, $33, $87, $30, $85, $2c, $87, $27, $83, $24, $87, $48, $20, $87, $1b, $85, $19, $85, $1e, $87, $22, $85, $25
	.byte $87, $2a, $83, $2e, $87, $31, $87, $36, $85, $3a, $85, $36, $87, $31, $85, $2e, $87, $2a, $83, $27, $87, $22, $87, $1e
	.byte $85, $1d, $85, $20, $87, $24, $85, $29, $87, $2c, $83, $30, $87, $35, $87, $38, $85, $3c, $85, $38, $87, $35, $85, $30
	.byte $87, $2c, $83, $29, $87, $48, $24, $87, $20, $85
	.byte $41, $60
	.word @song0ref177
	.byte $35, $85, $31, $87, $2e, $85, $2a, $87, $29, $83, $25, $87, $22, $87, $1e, $85, $1d, $85, $19, $87, $16, $85, $12, $87
	.byte $11, $83, $0d, $87, $48, $91, $7f, $94, $0d, $8f, $20, $8f, $22, $8d, $25, $8f, $28, $87, $27, $8b, $25, $89, $27, $85
	.byte $25, $8d, $22, $87, $25, $87, $22, $8b, $20, $89, $22, $85, $1d, $85, $9c, $38, $87, $45, $85, $38, $91, $45, $8f, $00
	.byte $8b, $48, $8d, $7a
@song0ref386:
	.byte $94, $2e, $b1, $29, $8f, $22, $8f, $27, $8f, $25
@song0ref396:
	.byte $8f, $00, $7f, $8d
@song0ref400:
	.byte $90, $3a, $93, $45, $85, $00, $93, $35, $9d, $45, $8d, $00, $83, $38, $91, $48, $45, $87, $00, $93, $33, $9b, $45, $8f
	.byte $00, $81, $35, $93, $45, $85, $00, $93, $31, $9d, $45, $8d, $00, $83, $33, $91, $45, $87, $00, $93, $2e, $9b, $45, $85
	.byte $48, $89, $00, $81, $7a, $94, $2e, $a1, $20, $8d, $22, $8f, $25, $8f, $27, $8f, $2e
	.byte $41, $34
	.word @song0ref396
	.byte $79
	.byte $41, $0b
	.word @song0ref386
	.byte $8d, $7f
	.byte $41, $2a
	.word @song0ref400
	.byte $94, $29, $8f, $2c, $8d, $2e, $81, $48, $8d, $31, $b1, $2e, $c7, $8e, $22, $8f, $45, $8f, $20, $8f, $45, $8d, $1e, $8f
	.byte $45, $8f, $1b, $8f, $45, $8b, $49, .lobyte(@env0), .hibyte(@env0), $4a, $00, $42
	.word @song0ch0loop
@song0ch1:
	.byte $9a
@song0ref516:
	.byte $36, $87, $33, $85, $2e, $87, $2a, $85, $36, $85, $33, $87, $2e, $85, $2a, $85
	.byte $41, $10
	.word @song0ref516
	.byte $41, $10
	.word @song0ref516
	.byte $41, $10
	.word @song0ref516
@song0ref541:
	.byte $38, $87, $35, $85, $30, $87, $2c, $85, $38, $85, $35, $87, $30, $85, $2c, $85
	.byte $41, $10
	.word @song0ref541
	.byte $41, $10
	.word @song0ref541
	.byte $41, $10
	.word @song0ref541
@song0ref566:
	.byte $3a, $87, $36, $85, $31, $87, $2e, $85, $3a, $85, $36, $87, $31, $85, $2e, $85
	.byte $41, $10
	.word @song0ref566
@song0ref585:
	.byte $3a, $87, $37, $85, $33, $87, $2e, $85, $3a, $85, $37, $87, $33, $85, $2e, $85
	.byte $41, $10
	.word @song0ref585
@song0ref604:
	.byte $38, $87, $33, $85, $31, $87, $2c, $85, $38, $85, $33, $87, $31, $85, $2c, $85
	.byte $41, $10
	.word @song0ref604
@song0ref623:
	.byte $38, $87, $33, $85, $30, $87, $2c, $85, $38, $85, $33, $87, $30, $85, $2c, $85
	.byte $41, $10
	.word @song0ref623
@song0ch1loop:
	.byte $00, $c3
@song0ref645:
	.byte $92, $22, $8f, $25, $8f, $29, $8f, $27, $9f, $25, $a1, $24, $9f, $25, $a1, $22, $8d, $87, $45, $b3, $00, $ff, $91, $1d
	.byte $8f, $1e, $8f, $20, $8f, $20, $8d, $91, $1d, $8f, $19, $a9, $45, $b3, $00, $c9, $1b, $8f, $20, $8f, $25, $8f, $24, $8d
	.byte $91, $22, $95, $45, $b5, $00, $ff, $8e, $2c, $8b, $45, $8f, $00, $81, $2e, $85, $45, $85, $9b, $00, $a7
	.byte $41, $0c
	.word @song0ref645
	.byte $2c, $a1, $29, $8d, $87, $45, $b3, $00, $ff, $91, $29, $8f, $27, $8f, $25, $8f, $24, $8d, $91, $25, $8f, $22, $a9, $45
	.byte $b3, $00, $c9, $29, $8f, $27, $8f, $25, $8f, $2c, $8d, $a3, $45, $e5, $8e, $30, $87, $45, $85, $30, $87, $45, $8d, $00
	.byte $dd, $a4
@song0ref767:
	.byte $16, $87, $19, $85, $20, $87, $22, $85, $25, $85, $2a, $87, $2e, $85, $31, $85, $36, $87, $31, $85, $2e, $87, $2a, $85
	.byte $25, $85, $22, $87, $1e, $85, $19, $85, $18, $87, $1b, $85, $20, $87, $24, $85, $27, $85, $2c, $87, $30, $85, $33, $85
	.byte $38, $87, $33, $85, $30, $87, $2c, $85, $27, $85, $24, $87, $20, $85, $1b, $85, $19, $87, $1e, $85, $22, $87, $25, $85
	.byte $2a, $85, $2e, $87, $31, $85, $36, $85, $3a, $87, $36, $85, $31, $87, $2e, $85, $2a, $85, $27, $87, $22, $85, $1e, $85
	.byte $1d, $87, $20, $85, $24, $87, $29, $85, $2c, $85, $30, $87, $35, $85, $38, $85, $3c, $87, $38, $85, $35, $87, $30, $85
	.byte $2c, $85, $29, $87, $24, $85, $20, $85
	.byte $41, $60
	.word @song0ref767
	.byte $35, $87, $31, $85, $2e, $87, $2a, $85, $29, $85, $25, $87, $22, $85, $1e, $85, $1d, $87, $19, $85, $16, $87, $12, $85
	.byte $11, $85, $0d, $87, $0a, $85, $06, $85, $45, $85, $00, $87, $96, $20, $87, $45, $85, $22, $85, $45, $87, $25, $85, $45
	.byte $85, $28, $85, $45, $81, $27, $83, $45, $83, $25, $83, $45, $83, $27, $83, $45, $81, $25, $85, $45, $81, $22, $83, $45
	.byte $83, $25, $85, $45, $81, $22, $83, $45, $83, $20, $83, $45, $83, $22, $83, $45, $81, $1d, $85, $45, $81, $1c, $83, $45
	.byte $83, $2c, $87, $45, $85, $2c, $8f, $45, $8f, $2e, $8d
@song0ref1005:
	.byte $93, $45, $8d, $29, $85, $45, $87, $22, $85, $45, $85, $27, $87, $45, $85, $25, $87, $45, $87, $00, $8d
@song0ref1026:
	.byte $92, $3a, $8f, $45, $9b, $00, $81, $35, $91, $45, $9d, $38, $91, $45, $99, $00, $81, $33, $91, $45, $9f, $35, $8f, $45
	.byte $9b, $00, $81, $31, $91, $45, $9d, $33, $91, $45, $99, $00, $81, $2e, $91, $45, $9f, $96, $2e, $8d, $91, $20, $89, $45
	.byte $83, $22, $87, $45, $85, $25, $87, $45, $83, $27, $89, $45, $83, $2e, $89, $45, $87, $00, $8b
	.byte $41, $2a
	.word @song0ref1026
	.byte $41, $39
	.word @song0ref1005
	.byte $96, $29, $87, $45, $85, $2c, $87, $45, $85, $2e, $85, $45, $87, $31, $8d, $a3, $2e, $e5, $8e, $25, $8f, $45, $8f, $24
	.byte $8f, $45, $8d, $22, $8f, $45, $8f, $20, $8f, $45, $8b, $00, $42
	.word @song0ch1loop
@song0ch2:
@song0ref1138:
	.byte $86, $1d
@song0ref1140:
	.byte $a1
@song0ref1141:
	.byte $84, $22, $9f, $86, $1d, $a1, $84, $22, $9f, $86, $1d, $a1, $84, $22, $9f
	.byte $41, $0c
	.word @song0ref1138
	.byte $41, $0c
	.word @song0ref1138
	.byte $41, $0c
	.word @song0ref1138
	.byte $41, $0c
	.word @song0ref1138
	.byte $86, $1d, $a1, $84, $22, $9f
@song0ch2loop:
	.byte $86, $1d, $c3, $1d
@song0ref1179:
	.byte $c3, $1d, $d5
@song0ref1182:
	.byte $1d, $8f, $84, $22, $8f, $86, $1d, $8d, $1d, $c3, $1d, $b3, $1d, $c3, $1d, $c3, $1d, $8d, $c5, $1d, $b3, $1d, $8d, $1d
	.byte $c3, $1d, $c3, $1d, $c3, $1d, $c3, $1d, $8f, $1d, $8f, $84, $22, $b1, $86
	.byte $41, $09
	.word @song0ref1182
	.byte $41, $25
	.word @song0ref1179
	.byte $9f, $86, $1e
	.byte $41, $0b
	.word @song0ref1140
	.byte $41, $0c
	.word @song0ref1138
	.byte $41, $0c
	.word @song0ref1138
	.byte $41, $0c
	.word @song0ref1138
	.byte $41, $0c
	.word @song0ref1138
	.byte $41, $0c
	.word @song0ref1138
	.byte $86, $1d, $ff, $89, $84, $22, $8f, $22, $a1, $86, $1d, $8d, $91, $1d, $8f
	.byte $41, $0a
	.word @song0ref1141
	.byte $41, $0c
	.word @song0ref1138
	.byte $86, $1d, $a1
@song0ref1272:
	.byte $84, $22, $9f, $86, $1d, $a1, $84, $22, $8f, $86, $1d, $8d, $91, $1d, $8f
	.byte $41, $0a
	.word @song0ref1141
	.byte $41, $0c
	.word @song0ref1138
	.byte $86, $1d, $8f, $1d, $8f
	.byte $41, $0b
	.word @song0ref1272
	.byte $41, $0a
	.word @song0ref1141
	.byte $41, $0c
	.word @song0ref1138
	.byte $86, $1d, $a1, $84, $22, $b1, $86, $1d, $8f, $84, $22, $9f, $86, $1d, $a1, $84, $22, $8f, $86, $1d, $9f, $1d, $8f, $84
	.byte $22, $9f, $86, $1d, $8f, $1d, $8f, $84, $22, $9f, $86, $1d, $a1, $84, $22, $9f, $42
	.word @song0ch2loop
@song0ch3:
@song0ref1350:
	.byte $82, $1f, $a1
@song0ref1353:
	.byte $80, $21
@song0ref1355:
	.byte $9f, $82, $1f, $a1, $80, $21, $9f, $82, $1f, $a1, $80, $21, $9f
	.byte $41, $0c
	.word @song0ref1350
	.byte $41, $0c
	.word @song0ref1350
	.byte $41, $0c
	.word @song0ref1350
	.byte $41, $0c
	.word @song0ref1350
	.byte $82, $1f, $a1, $80, $21, $9f
@song0ch3loop:
	.byte $41, $0b
	.word @song0ref1350
@song0ref1390:
	.byte $b1, $82, $1f, $8f
@song0ref1394:
	.byte $80, $21, $8f, $82, $1f, $8d
@song0ref1400:
	.byte $1f, $a1, $80, $21, $9f, $82, $1f, $a1, $80, $21, $8f, $82, $1f, $b1, $80, $21, $8f, $82, $1f, $b1, $80, $21, $8f, $82
	.byte $1f, $8d, $a3, $80, $21, $9f, $82, $1f, $a1
	.byte $41, $0b
	.word @song0ref1394
	.byte $41, $09
	.word @song0ref1355
	.byte $82, $1f, $8f, $1f, $8f, $80, $21
	.byte $41, $0e
	.word @song0ref1390
	.byte $9f, $82, $1f, $a1, $80, $21
	.byte $41, $1e
	.word @song0ref1390
	.byte $41, $0b
	.word @song0ref1394
	.byte $41, $09
	.word @song0ref1355
	.byte $82, $1f, $8f, $1f, $8f
	.byte $41, $0a
	.word @song0ref1353
	.byte $41, $0c
	.word @song0ref1350
	.byte $41, $0c
	.word @song0ref1350
	.byte $41, $0c
	.word @song0ref1350
	.byte $41, $0c
	.word @song0ref1350
	.byte $41, $0c
	.word @song0ref1350
	.byte $82, $1f, $a1, $80, $21, $9f, $82, $1f, $ff, $89, $80, $21, $8f, $21, $a1, $82, $1f, $8d, $91, $1f, $8f
	.byte $41, $0a
	.word @song0ref1353
	.byte $41, $0c
	.word @song0ref1350
	.byte $82
	.byte $41, $09
	.word @song0ref1400
	.byte $8d, $91, $1f, $8f
	.byte $41, $0a
	.word @song0ref1353
	.byte $41, $0c
	.word @song0ref1350
@song0ref1528:
	.byte $82, $1f, $8f, $1f, $8f, $80, $21, $9f, $82, $1f, $a1, $80, $21, $8f, $82, $1f, $8d, $91, $1f, $8f
	.byte $41, $0a
	.word @song0ref1353
	.byte $41, $0c
	.word @song0ref1350
	.byte $82, $1f, $a1, $80, $21, $9f
	.byte $41, $0b
	.word @song0ref1528
	.byte $9f, $1f, $8f
	.byte $41, $0a
	.word @song0ref1353
	.byte $42
	.word @song0ch3loop
@song0ch4:
@song0ref1572:
	.byte $12, $8f, $12, $8f, $12, $8f, $12, $8d, $12, $8f, $12, $8f, $12, $8f, $12, $8d
	.byte $41, $10
	.word @song0ref1572
@song0ref1591:
	.byte $13, $8f, $13, $8f, $13, $8f, $13, $8d, $13, $8f, $13, $8f, $13, $8f, $13, $8d
	.byte $41, $10
	.word @song0ref1591
@song0ref1610:
	.byte $10, $8f, $10, $8f, $10, $8f, $10, $8d, $10, $8f, $10, $8f, $10, $8f, $10, $8d, $0f, $8f, $0f, $8f, $0f, $8f, $0f, $8d
	.byte $0f, $8f, $0f, $8f, $0f, $8f, $0f
@song0ref1641:
	.byte $8d
@song0ref1642:
	.byte $11, $8f, $11, $8f, $11, $8f, $11, $8d, $11, $8f, $11, $8f, $11, $8f, $11
	.byte $41, $10
	.word @song0ref1641
	.byte $8d
@song0ch4loop:
@song0ref1662:
	.byte $08, $a1, $0e, $c3, $0e, $c3, $0e, $b1, $05, $a1, $02, $8d, $a3, $0e, $c3, $0e, $8f, $05, $b1, $0e, $8f, $04, $b1, $0e
	.byte $8f, $01, $8d, $a3, $0e, $c3, $0e, $8f, $04, $b1, $0e, $c3, $0e, $8f, $02, $8d, $a3, $0e, $c3, $0e, $9f, $05, $8f, $02
	.byte $8f, $05, $b1, $05, $a1, $08, $8d
	.byte $41, $2f
	.word @song0ref1662
	.byte $05, $b1, $08, $a1, $05, $9f
	.byte $41, $10
	.word @song0ref1610
	.byte $41, $10
	.word @song0ref1591
	.byte $41, $10
	.word @song0ref1572
	.byte $41, $10
	.word @song0ref1591
	.byte $41, $10
	.word @song0ref1610
	.byte $41, $10
	.word @song0ref1591
	.byte $41, $10
	.word @song0ref1572
	.byte $41, $0f
	.word @song0ref1642
	.byte $8d, $91, $05, $8f, $08, $8f, $06, $8d, $0a, $89, $09, $89, $06, $89, $09, $87, $06, $89, $08, $89, $06, $89, $08, $89
	.byte $05, $89, $08, $87, $04, $89, $03, $89, $05, $8f, $05, $a1
@song0ref1786:
	.byte $05, $8d, $91
@song0ref1789:
	.byte $07, $8f, $08, $8f, $05, $8d, $07, $8f, $08, $8f, $05, $8f, $07, $8d, $08, $8f, $05, $8f, $07, $8f, $08, $8d, $05, $8f
	.byte $41, $18
	.word @song0ref1789
	.byte $41, $0c
	.word @song0ref1789
	.byte $41, $1b
	.word @song0ref1786
	.byte $41, $18
	.word @song0ref1789
	.byte $41, $0c
	.word @song0ref1789
	.byte $41, $1b
	.word @song0ref1786
	.byte $41, $18
	.word @song0ref1789
	.byte $41, $0c
	.word @song0ref1789
	.byte $41, $11
	.word @song0ref1786
	.byte $01, $8f, $09, $8f, $04, $8f, $0b, $8d, $02, $8f, $0c, $8f, $05, $8f, $0d, $8d, $42
	.word @song0ch4loop
@song1ch0:
@song1ch0loop:
	.byte $47, .lobyte(@tempo_env_1_mid), .hibyte(@tempo_env_1_mid)
@song1ref5:
	.byte $ff, $9f, $48, $ff, $9f, $48, $ff, $9f, $48, $ff, $9f, $48
	.byte $41, $08
	.word @song1ref5
	.byte $42
	.word @song1ch0loop
@song1ch1:
@song1ch1loop:
	.byte $7f, $9e, $27, $85, $43, $29, $87, $45, $76, $29, $85, $45, $7f, $28, $85, $45, $25, $8f, $45, $76, $25, $85, $45, $7f
	.byte $22, $85, $45, $27, $8f, $45, $76, $27, $85, $45, $7f, $25, $85, $45, $22, $8f, $45, $76, $22, $85, $45, $7f, $20, $85
	.byte $45, $1d, $8f, $45, $76, $1d, $85, $45, $20, $85, $45, $7f, $25, $91, $43, $50, $24, $31, $2b, $87, $43, $1f, $85, $45
	.byte $00, $91, $24, $85, $43, $25, $49, .lobyte(@env20), .hibyte(@env20), $93, $43, $50, $56, $31, $25, $87, $49, .lobyte(@env0)
	.byte .hibyte(@env0), $4a, $9e, $25, $85, $45, $24, $85, $45, $22, $8f, $45, $25, $8f, $45, $22, $8f, $45, $20, $85, $45
	.byte $00, $87, $1c, $85, $43, $1d, $87, $45, $20, $85, $45, $00, $87, $1d, $8f, $45, $19, $85, $45, $00, $87, $1c, $8f, $45
	.byte $1b, $85, $45, $00, $87, $19, $8f, $45, $15, $85, $43, $16, $49, .lobyte(@env20), .hibyte(@env20), $9f, $43, $50, $72
	.byte $22, $16, $8f, $49, .lobyte(@env0), .hibyte(@env0), $4a, $00, $a5, $9e, $16, $87, $43, $19
@song1ref192:
	.byte $85, $45, $1d, $85, $45, $20, $87, $43, $22
	.byte $41, $08
	.word @song1ref192
	.byte $87, $43, $25, $85, $45, $29, $85, $45, $2c, $87, $43, $2e, $85, $45, $31, $87, $43, $35, $87, $43, $31, $85, $45, $2e
	.byte $85, $45, $34, $87, $43, $33, $85, $45, $31, $85, $45, $2e, $85, $45, $31, $87, $43, $2e, $85, $45, $2c, $85, $45, $29
	.byte $85, $45, $2c, $87, $43, $29, $85, $45, $25, $85, $45, $29, $87, $43, $25, $85, $45, $22, $85, $45, $20, $87, $43, $22
	.byte $85, $45, $a0
@song1ref279:
	.byte $2a, $87, $43, $22, $87, $43, $25, $87, $2a, $87, $43, $22, $87, $43, $25, $87
	.byte $41, $0c
	.word @song1ref279
	.byte $2a, $87, $43, $22, $87, $43, $25, $87, $43, $2a, $87, $2c, $87, $43, $27, $87, $2c, $87, $43, $27, $87, $2c, $87, $43
	.byte $27, $87, $30, $87, $43, $2c, $87, $30, $87, $43, $2c, $87, $30, $87, $43, $2c, $87, $43, $50, $fe, $36, $38, $a5, $42
	.word @song1ch1loop
@song1ch2:
@song1ch2loop:
	.byte $a2
@song1ref350:
	.byte $08, $87, $43, $0a, $97
@song1ref355:
	.byte $00, $81, $16, $87, $43, $50, $7f, $22, $16, $87, $0a, $83, $00, $81, $0a, $83, $00, $81, $14, $8d, $00, $81, $11, $8d
	.byte $00, $81, $14, $8d, $00, $81, $0a, $8d, $00, $81, $11, $8d, $00, $81, $0a, $8d, $00, $81, $10, $8d, $00, $81, $0a, $8d
	.byte $00, $81, $0f, $8d, $00, $81, $0d, $8d, $00, $81, $08, $8d, $00, $81, $08, $87, $43, $0a, $87, $a3
	.byte $41, $1a
	.word @song1ref355
	.byte $16, $8d, $00, $81, $12, $8d, $00, $81, $06, $8d, $00, $81, $12, $8d, $00, $81, $11, $a1, $00, $81, $11, $83, $00, $81
	.byte $11, $83, $00, $81, $14, $8d, $00, $81, $15, $8d, $00, $81
	.byte $41, $37
	.word @song1ref350
	.byte $97, $00, $81, $0c, $83, $00, $81, $0d, $83, $00, $81, $0e, $83
@song1ref478:
	.byte $00, $81, $03, $8d, $00, $81, $0f, $8d
	.byte $41, $08
	.word @song1ref478
	.byte $41, $08
	.word @song1ref478
	.byte $00, $81, $0d, $8d, $00, $81, $0f, $8d, $00, $81, $05, $8b, $00, $83, $05, $8b, $00, $83, $05, $8b, $00, $83, $05, $95
	.byte $00, $83, $05, $81, $00, $83, $05, $8b, $00, $83, $08, $8b, $00, $83, $09, $8b, $00, $83, $42
	.word @song1ch2loop
@song1ch3:
@song1ch3loop:
	.byte $7f
@song1ref539:
	.byte $98, $1f, $a5
@song1ref542:
	.byte $8a, $1c, $91, $88, $1f, $91, $8c, $1d, $87, $00, $87, $88, $1f, $91
	.byte $41, $0a
	.word @song1ref542
	.byte $41, $0a
	.word @song1ref542
	.byte $41, $0a
	.word @song1ref542
	.byte $41, $0a
	.word @song1ref542
	.byte $41, $0a
	.word @song1ref542
	.byte $41, $0a
	.word @song1ref542
	.byte $8a, $1c, $91, $1c, $91
	.byte $41, $0c
	.word @song1ref539
	.byte $41, $0a
	.word @song1ref542
	.byte $8a, $1c, $91, $88, $1f, $91, $00, $91, $1f, $91
	.byte $41, $0a
	.word @song1ref542
	.byte $41, $0a
	.word @song1ref542
	.byte $8a, $1c, $91, $88
@song1ref605:
	.byte $1f, $91, $8a, $1c, $91, $8c, $1d, $87, $00, $87, $98
	.byte $41, $08
	.word @song1ref605
	.byte $98, $1f, $91, $8a, $1c, $91, $1c, $91, $42
	.word @song1ch3loop
@song1ch4:
@song1ch4loop:
@song1ref631:
	.byte $ff, $9f, $ff, $9f, $ff, $9f, $ff, $9f
	.byte $41, $08
	.word @song1ref631
	.byte $42
	.word @song1ch4loop
