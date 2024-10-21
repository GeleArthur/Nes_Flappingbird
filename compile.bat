@echo off

set "GameName=4FlappyBirds"
mkdir build 2>nul

@echo Compiling...
ca65 src/main.s -g -o build/%GameName%.o
@if errorlevel 1 goto error
@echo Linking...
ld65 -o build/%GameName%.nes -C cfg/linker_config.cfg build/%GameName%.o -m build/%GameName%.map.txt -Ln build/%GameName%.labels.txt --dbgfile build/%GameName%.nes.dbg
@if errorlevel 1 goto error

:success
@echo Compilation successful!
goto end
:error
@echo Compilation failed!
goto end


:end
