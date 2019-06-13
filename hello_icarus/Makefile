.PHONY: all
all:
	iverilog -o hello.o hello_world.v

.PHONY: run
run:
	vvp.exe hello.o

.PHONY: clean
clean:
	rm hello.o
