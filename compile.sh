#! /bin/bash

GameName=4FlappyBirds
mkdir build &> /dev/null

ca65 src/main.s -g -o build/$GameName.o
if [ $? -ne 0 ]; then
    exit 1
fi
    
ld65 -o build/$GameName.nes \
    -C cfg/linker_config.cfg build/$GameName.o \
    -m build/$GameName.map.txt \
    -Ln build/$GameName.labels.txt \
    --dbgfile build/$GameName.nes.dbg
if [ $? -ne 0 ]; then
    exit 1
fi

echo "Compilation successful!"
