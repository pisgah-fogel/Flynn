NOP
LD 00000111 ; A
MOV r1 r0
LD 00001000 ; B
ADD ; r0 = r1 + r0 = 0x0F
LD 10000000 ; A
MOV r1 r0
LD 10000000 ; B
ADD ; r0 = r1 + r0 = 0x00 and r_C = 1
LD 00000001 ; A
MOV r1 r0
LD 00000011 ; B
ADD ; r0 = r1 + r0 = 0x04 and r_C = 0 (reset flag)
NOP
NOP
NOP
