#
# Makefile can be used either on Linux or Windows
# Please install cygwin or gitbash for window in order to have bash
# Please install icarus
#
#
# Complete with Linux or Win64 depending on your system
OS = "LINUX"

SHELL := /bin/bash # required for advanced scripting

# Setup depends of the operating system
ifeq ($(OS), Win64)
	IVERILOG = "iverilog"
	VVP = "vvp.exe"
else
	IVERILOG = "iverilog"
	VVP = "vvp"
endif

# Update thoses lines if you need to
SRC = "st7735s_tb.v"
OUTPUT = "st7735s.o"

.PHONY: all
all: ${OUTPUT}

.PHONY: run
run: ${OUTPUT}
	${VVP} ${OUTPUT}

.PHONY: clean
clean:
	@{ \
		if [ -f ${OUTPUT} ]; \
		then \
			rm ${OUTPUT}; \
			rm -f *.vcd \
		else \
			echo "Nothing to clean"; \
		fi; \
	}


${OUTPUT}:
	${IVERILOG} -o ${OUTPUT} ${SRC}
