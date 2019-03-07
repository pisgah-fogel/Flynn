# The Flynn project

This project aims write hardware description of soft CPU for educatif
purpose.

## Why "Flynn project"

Because of the Flynn's taxonomy [See wikipedia
article](https://en.wikipedia.org/wiki/Flynn%27s\_taxonomy) introducing the
[SISD](https://en.wikipedia.org/wiki/SISD),
[SIMD](https://en.wikipedia.org/wiki/SIMD),
[MISD](https://en.wikipedia.org/wiki/MISD) and
[MIMD](https://en.wikipedia.org/wiki/MIMD) architecture.

This project concists of
various soft CPU architecture implementation so we decided make a reference to
one of the classification method.

## Language

Q: Why verilog ?
A: Soft-CPU contests (see [RISC-V weeb
page](https://riscv.org/2018/10/risc-v-contest/) mainly use it, however I a
familiar with VHDL and use it everyday I decided to limit this project to
verilog. Futhermore there is great open sources tools targeting verilog.

Q: Other used language ?
A: For scripting we use python (portable, easy to edit, ...) and C/C++ for software
development requiring performance.

Q: Supported development operating système ?
A: Project tested on linux, should works on Windows but to tested yet.

Q: Compatible FPGA ?
A: Every soft CPU are developped for FPGA (signals initial values...), only
tested on old FPGA but is you can affort a state-of-the-art FPGA your feedback
is welcome.

FPGA in my possession: Xilinx Spartan6, Altera Cyclone II

## GuidelLines

CPU I would like to develop:
[ ] SISD - a basic 8b CPU
[ ] Pipeline acceleration (in-order)
[ ] Pipeline acceleration + tomasulo algorithm (cf [Out of order
execution](https://en.wikipedia.org/wiki/Out-of-order_execution)
[ ] Stack - a 8b stack based CPU
[ ] Vectorial
[ ] SuperScalar
[ ] SIMD
[ ] SIMD + FPU
[ ] MultiThread
[ ] Many cores
[ ] VLIW - Very Long Instruction Word (cf [Super Harvard Architecture
Single-Chip
Computer](https://en.wikipedia.org/wiki/Super_Harvard_Architecture_Single-Chip_Computer)
[ ] [SIMT](https://en.wikipedia.org/wiki/Single\_instruction,\_multiple\_threads) - Single Instruction Multiple Thread = SIMD + Threading
[ ] 

## Interesting reference
- [GPGPU](https://en.wikipedia.org/wiki/General-purpose_computing_on_graphics_processing_units)
  Use GPU to perform computation usually handled by the CPU.
- [Computer Organization and
  Design](https://books.google.fr/books?id=3b63x-0P3_UC) by David A.
Patterson  and John L. Hennessy.
