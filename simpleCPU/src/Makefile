
default_target: all

.PHONY : all clean

SHELL = /bin/bash
CMAKE_COMMAND = /usr/bin/cmake
ARGS = -Wall -Winfloop
CC = iverilog
OPT = 

all: ../a.out

../a.out:
	$(CC) $(ARGS) top_wrapper_tb.v -o ../a.out

clean:
	rm -f ../a.out

synthesis:
	yosys -p "synth_ice40 -blif cpu.blif" cpu.v
