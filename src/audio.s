.include "famistudio_ca65.s"
.include "bg_music.s"


.proc audio_init
	; load music data address from "mygame_music.s"
	LDX #.lobyte(music_data_floppy_birds)
	LDY #.hibyte(music_data_floppy_birds)

	; non-zero for NTSC
	lda #0

	; initialize music engine
	jsr famistudio_init

	RTS
.endproc

.export audio_title_screen
.proc audio_title_screen
	jsr famistudio_music_stop
	lda #0
	jsr famistudio_music_play
	RTS
.endproc

.export audio_main_game
.proc audio_main_game
	jsr famistudio_music_stop
	lda #1
	jsr famistudio_music_play
	RTS
.endproc