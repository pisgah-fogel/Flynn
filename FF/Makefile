
default_target: all

.PHONY : all test

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
	$(CC) $(ARGS) ff_tb.v

clean:
	rm a.out mydump.vcd
	rm ff.blif

synthesis:
	yosys -p "synth_ice40 -blif ff.blif" ff-rtl.v

