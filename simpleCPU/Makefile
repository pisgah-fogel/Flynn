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

#TEST = str_test.mem
#TEST = je_test.mem
TEST = jmp_test.mem
SHELL = /bin/bash
CMAKE_COMMAND = /usr/bin/cmake
ARGS = -Wall -Winfloop
CC = iverilog
OPT = 

plot: all
	gtkwave mydump.vcd &

all: mydump.vcd

test: a.out

mydump.vcd: a.out rom.mem ram.mem
	./a.out

a.out:
	cd src; make all; cd ../

rom.mem: programs
	rm -f rom.mem
	ln -s programs/$(TEST)  rom.mem

ram.mem:
	utils/gen_blank_ram.sh ram.mem

programs:
	cd programs; ./compile.sh all; cd ../

cocotb: ram.mem rom.mem
	cd cocotb/ram; make ; cd ../..

clean:
	rm -f *.vcd
	cd programs; ./compile.sh clean; cd ../
	cd src; make clean; cd ../
	cd verif/ram/; make clean; cd ../..
	cd verif/reset_sync/; make clean; cd ../..
	cd debugger/; make clean; cd ..
	rm -f cpu.blif
	rm -f log.txt
	rm -f *.mem
	rm -f *.log
	rm -f top_wrapper.blif
	rm -rf tests/__pycache__/
	cd cocotb/ram; make clean_all; cd ../..

synthesis:
	yosys -p "synth_ice40 -blif cpu.blif" src/cpu.v
