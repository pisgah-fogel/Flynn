VERILATOR_PATH="/usr/share/verilator"
VERILATOR_EXE="verilator"
MAIN_VERILOG_MODULE="top_module"
VERILOG_PATH="../src"

all: ${MAIN_VERILOG_MODULE}

${MAIN_VERILOG_MODULE}: obj_dir/V${MAIN_VERILOG_MODULE}__ALL.a
	g++ -I ${VERILATOR_PATH}/include/ -I obj_dir/ ${VERILATOR_PATH}/include/verilated.cpp ${VERILATOR_PATH}/include/verilated_vcd_c.cpp main.cpp obj_dir/V${MAIN_VERILOG_MODULE}__ALL.a -o ${MAIN_VERILOG_MODULE}

obj_dir/V${MAIN_VERILOG_MODULE}__ALL.a:
	${VERILATOR_EXE} -Wall -Wno-UNUSED --trace -cc  ${VERILOG_PATH}/${MAIN_VERILOG_MODULE}.v && cd obj_dir/ && make -f V${MAIN_VERILOG_MODULE}.mk

clean:
	rm -rf obj_dir/
	rm -f ${MAIN_VERILOG_MODULE}
	rm -f ${MAIN_VERILOG_MODULE}trace.vcd
