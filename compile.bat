@echo off

set "GameName=4FlappyBirds"
mkdir build 2>nul

ca65 src/main.s -g -o build/%GameName%.o
ld65 -o build/%GameName%.nes -C cfg/linker_config.cfg build/%GameName%.o -m build/%GameName%.map.txt -Ln build/%GameName%.labels.txt --dbgfile build/%GameName%.nes.dbg
