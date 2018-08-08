.data
.equ TAMANHO_ENTRADA, 574
.equ UART_ADDRESS, 0x9050
.equ CONTROL_ADDRESS, 0x9040
.equ CONTROL_CLR, 0x9030


BASE_DADOS_ENDERECO: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

.text

.global _start
_start: 
movia r1, TAMANHO_ENTRADA
movia r2, UART_ADDRESS
movia r3, CONTROL_ADDRESS
movia r4, CONTROL_CLR
movia r9, BASE_DADOS_ENDERECO
movia r22, BASE_DADOS_ENDERECO

mov r6, r0 #32 bits
movi r5, 0 #offset inicial
movi r17, 24

checar_empty:
ldwio r10, 0(r3)
bne r10, r0, chegou_caractere
br checar_empty

chegou_caractere:
ldwio r12, 0(r2)
movi r8, 1
stwio r8, 0(r4)
stwio r0, 0(r4)
sll r12, r12, r5
or r6, r6, r12

beq r5, r17, reinicia_offset #offset chegou em 24
addi r5, r5, 8 #aumenta 8 do offset
br computar_numero_bytes

reinicia_offset:
stw r6, 0(r9)
addi r9, r9, 4
movi r5, 0
mov r6, r0
br computar_numero_bytes

computar_numero_bytes:
addi r7, r7, 1 #incrementa contador de bytes
beq r7, r1, exibicao_vga
br checar_empty

exibicao_vga:
mov r19, r7
movi r1, 0
movi r2, 63
mov r6, r0
movia r7, BASE_DADOS_ENDERECO
addi r7, r7, 64
movia r10, 0b1000000
br inicia


inicia:
ldw r4, 0(r7)
addi r7, r7, 4
ldw r5, 0(r7)
addi r7, r7, 4
#bne r6, r2, gravarMem
#br fim

gravarMem: 
custom 0, r11, r6, r4
or r3, r6, r10
custom 0, r11, r3, r5
addi r6, r6, 1
beq r6, r2, fim
br inicia

fim:
br fim