
default_target: all

.PHONY : all

#TEST = prog/load_test.asm
TEST = prog/add_test.asm
SHELL = /bin/bash
CMAKE_COMMAND = /usr/bin/cmake
ARGS = -Wall -Winfloop
CC = iverilog
OPT = 

all: mydump.vcd
	gtkwave mydump.vcd

test: a.out

mydump.vcd: a.out
	./a.out

a.out: rom.mem
	$(CC) $(ARGS) top_wrapper_tb.v

rom.mem:
	python asm.py -Wall $(TEST) -o rom.mem

clean:
	rm -f a.out mydump.vcd
	rm -f rom.mem
	rm -f cpu.blif
	rm -f top_wrapper.blif

synthesis:
	yosys -p "synth_ice40 -blif cpu.blif" cpu.v
