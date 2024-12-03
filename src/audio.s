.include "famistudio_ca65.s"
.include "bg_music.s"


.proc audio_init
	; load music data address from "mygame_music.s"
	LDX #.lobyte(music_main_game)
	LDY #.hibyte(music_main_game)

	; non-zero for NTSC
	LDA #0

	; initialize music engine
	JSR famistudio_init

	RTS
.endproc

.export audio_title_screen
.proc audio_title_screen
	JSR famistudio_music_stop
	LDA #0
	JSR famistudio_music_play
	RTS
.endproc