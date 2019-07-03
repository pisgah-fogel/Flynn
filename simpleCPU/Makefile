#
# This is the main makefile
# It compiles the project and call Makefiles and scripts in other directories
# Main usages are:
# make all
# make clean
# make synthesis
#

default_target: all

.PHONY : all programs clean synthesis test plot

#TEST = load_test.mem
TEST = add_test.mem
SHELL = /bin/bash
CMAKE_COMMAND = /usr/bin/cmake
ARGS = -Wall -Winfloop
CC = iverilog
OPT = 

plot: all
	gtkwave mydump.vcd

all: mydump.vcd

test: a.out

mydump.vcd: a.out rom.mem ram.mem
	./a.out

a.out:
	cd src; make all; cd ../

rom.mem: programs
	ln -s programs/$(TEST)  rom.mem

ram.mem:
	utils/gen_blank_ram.sh ram.mem

programs:
	cd programs; ./compile.sh all; cd ../

clean:
	rm -f mydump.vcd
	cd programs; ./compile.sh clean; cd ../
	cd src; make clean; cd ../
	rm -f cpu.blif
	rm -f rom.mem
	rm -f log.txt
	rm -f ram.mem
	rm -f top_wrapper.blif

synthesis:
	yosys -p "synth_ice40 -blif cpu.blif" src/cpu.v
