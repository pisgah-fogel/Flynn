NOP
LD 00000111 ; A
MOV r1 r0
LD 00001000 ; B
XOR ; r0 = r1 xor r0 = 0x0f
LD 11111111 ; A
MOV r1 r0
LD 11111111 ; B
XOR ; r0 = r1 xor r0 = 0x00
LD 10101010 ; A
MOV r1 r0
LD 10011100 ; B
XOR ; r0 = r1 xor r0 = 0x36
NOP
NOP
NOP
