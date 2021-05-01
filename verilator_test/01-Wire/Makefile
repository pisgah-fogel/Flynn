
all: thruwire

thruwire: obj_dir/Vthruwire__ALL.a
	g++ -I /usr/share/verilator/include/ -I obj_dir/ /usr/share/verilator/include/verilated.cpp main.cpp obj_dir/Vthruwire__ALL.a -o thruwire

obj_dir/Vthruwire__ALL.a:
	verilator  -Wall -cc  thruwire.v && cd obj_dir/ && make -f Vthruwire.mk

clean:
	rm -rf obj_dir/
	rm -f thruwire
