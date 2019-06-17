
default_target: all

.PHONY : all

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

a.out:
	$(CC) $(ARGS) top_wrapper_tb.v

clean:
	rm a.out mydump.vcd
	rm cpu.blif
	rm top_wrapper.blif

synthesis:
	yosys -p "synth_ice40 -blif cpu.blif" cpu.v
