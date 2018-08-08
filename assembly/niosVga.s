.text

.global _start
_start:
movi r1, 32
movi r2, 64
movia r4, 0b11111111110111110111111011111111
movia r5, 0b11111111110111110111111011111111
movi r6, 32

inicia:
movi r10, 0b1000000
bne r6, r2, gravarMem
bne r1, r2, gravarMem2
br fim


gravarMem: 
custom 0, r11, r6, r4
addi r6, r6, 1
br inicia

gravarMem2:
or r3, r1, r10
custom 0, r11, r3, r5
addi r1, r1, 1
br inicia

fim:
br fim