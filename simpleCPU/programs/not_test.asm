NOP
LD 00010000 ; A
NOT ; R0 = not A = 0xff
LD 11111111
NOT ; R0 = not A = 0x00
LD 11110000
NOT ; R0 = not A = 0x0f
LD 00001111
NOT ; R0 = not A = 0xf0
NOP
NOP