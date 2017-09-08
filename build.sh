#/bin/sh
mkdir build
nasm src/boot.asm -o build/boot -Ov
nasm src/main.asm -o build/main	-Ov
cat build/boot > snake.flp
cat build/main >> snake.flp
