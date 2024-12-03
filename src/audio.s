.include "famistudio_ca65.s"
.include "bg_music.s"


.proc audio_init
	; load music data address from "mygame_music.s"
	LDX #.lobyte(music_data_floppy_birds)
	LDY #.hibyte(music_data_floppy_birds)

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

.export audio_title_screen
.proc audio_main_game
	JSR famistudio_music_stop
	LDA #1
	JSR famistudio_music_play
	RTS
.endproc