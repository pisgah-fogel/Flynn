
default_target: all

SHELL = /bin/bash
ISEVERSION = 14.7
ISEROOT = /Xilinx/$(ISEVERSION)/ISE_DS/ISE/bin/lin64
ISETCL = $(ISEROOT)/xtclsh
ISEIMPACT = $(ISEROOT)/impact

.PHONY: all clean program

all: project_1/top_module.bit

project_1/top_module.bit:
	mkdir project_1 &&\
	cd project_1 &&\
	$(ISETCL) ../Nexys3.tcl rebuild_project &&\
	cd ..

program: # need privilege for JTAG interface and Xilinx ISE cable drivers
	sudo $(ISEIMPACT) -batch program.cmd # check in program.cmd that device
#number is right

program_vivado:
	vivado -mode batch -source program_vivado.tcl

clean:
	rm -rf project_1/ _impactbatch.log Nexys3/ vivado* .Xil/ webtalk.*

