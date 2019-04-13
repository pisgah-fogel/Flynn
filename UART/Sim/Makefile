
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
	$(CC) $(ARGS) UART_tb.v

clean:
	rm a.out mydump.vcd
	rm uart.blif
	rm top_module.blif

synthesis:
	yosys -p "synth_ice40 -blif uart.blif" UART-nandland.v

top:
	$(CC) $(ARGS) top_module_tb.v
	./a.out
	gtkwave mydump.vcd

	

