# Simple CPU

A soft CPU experimentation.

This project's functionality is not guaranteed.
It only aims at beeing a 8 bits CPU with a 9 bits instruction set.

Why 9 bits ? Well it appears that I have a Spartan 6 (lx45) FPGA with 9bits RAM blocks
and I want to test different soft CPU approach with only 9 bits for theirs instructions.

## About this experimentation
This CPU is an SISD (Single Instruction on Single Data)
It is connected to ROM from with it will read it's instruction (on my FPGA I use RAM blocks)
And it can read and write to RAM (LDR and STR instructions).

You can use some RAM addresses as registers in order to implement
GPIO, SPI, I2C or any interaction with others IPs...
There is not AXI or WIshbone bus in this design


## Instruction set
Instruction shortname |  bits (MSB - LSB) | Operation
-----------------------------------------------------
        LD            | V V V V V V V V 1 | R0 <- V
        MOV           | A A A B B B 1 0 0 | A <- B
        CMP           | A A A B B B 1 1 0 | CMP A and B
        JE            | 0 0 0 0 0 1 0 0 0 | PC <- R1, R0 if FE=1 (flag equals)
        JG            | 0 0 0 0 1 1 0 0 0 | PC <- R1, R0 if FG=1 (flag greater)
        JL            | 0 0 0 1 0 1 0 0 0 | PC <- R1, R0 if FL=1 (flag lower)
        JMP           | 0 0 0 1 1 1 0 0 0 | PC <- R1, R0
        ADD           | 0 0 1 0 0 1 0 0 0 | R0 <- R0 + R1
        AND           | 0 0 1 0 1 1 0 0 0 | R0 <- R0 & R1
        OR            | 0 0 1 1 0 1 0 0 0 | R0 <- R0 | R1
        NOT           | 0 0 1 1 1 1 0 0 0 | R0 <- ! R0
        XOR           | 0 1 0 0 0 1 0 0 0 | R0 <- R0 ^ R1
        LDR           | 0 1 0 0 1 1 0 0 0 | R0 <- RAM[R2, R1]
        STR           | 0 1 0 1 0 1 0 0 0 | RAM[R2, R1] <- R0
        NOP           | 0 1 0 1 1 1 0 0 0 | No operation
