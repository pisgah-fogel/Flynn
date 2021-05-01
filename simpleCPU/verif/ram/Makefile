VERILATOR_PATH="/usr/share/verilator"
VERILATOR_EXE="verilator"
MAIN_VERILOG_MODULE="ram"
VERILOG_PATH="../../src"
DEFAULT_RAM=1
WIDTH=12

all: ${MAIN_VERILOG_MODULE}

${MAIN_VERILOG_MODULE}: obj_dir/V${MAIN_VERILOG_MODULE}__ALL.a ram.mem
	g++ -g -I ${VERILATOR_PATH}/include/ -I obj_dir/ ${VERILATOR_PATH}/include/verilated.cpp ${VERILATOR_PATH}/include/verilated_vcd_c.cpp main.cpp obj_dir/V${MAIN_VERILOG_MODULE}__ALL.a -o ${MAIN_VERILOG_MODULE}

obj_dir/V${MAIN_VERILOG_MODULE}__ALL.a:
	${VERILATOR_EXE}  -Wall --trace -cc  ${VERILOG_PATH}/${MAIN_VERILOG_MODULE}.v && cd obj_dir/ && make -f V${MAIN_VERILOG_MODULE}.mk

ram.mem:
	python -c "print(('${DEFAULT_RAM}'*9+'\n')*2048)" > ram.mem

clean:
	rm -rf obj_dir/
	rm -f ${MAIN_VERILOG_MODULE}
	rm -f ${MAIN_VERILOG_MODULE}trace.vcd
	rm -f ram.mem
