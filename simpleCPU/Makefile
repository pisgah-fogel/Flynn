
default_target: all

.PHONY : all programs clean synthesis test

#TEST = load_test.mem
TEST = add_test.mem
SHELL = /bin/bash
CMAKE_COMMAND = /usr/bin/cmake
ARGS = -Wall -Winfloop
CC = iverilog
OPT = 

all: mydump.vcd
	gtkwave mydump.vcd

test: a.out

mydump.vcd: a.out rom.mem
	./a.out

a.out:
	$(CC) $(ARGS) top_wrapper_tb.v

rom.mem: programs
	ln -s programs/$(TEST)  rom.mem

programs:
	cd programs; ./compile.sh all; cd ../

clean:
	rm -f a.out mydump.vcd
	cd programs; ./compile.sh clean; cd ../
	rm -f cpu.blif
	rm -f rom.mem
	rm -f top_wrapper.blif

synthesis:
	yosys -p "synth_ice40 -blif cpu.blif" cpu.v
