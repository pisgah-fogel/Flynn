#!/bin/bash

if [ $# -eq 1 ]
then
	if [ $1 = "--help" ]
	then
		echo "Options are:"
		echo "all | Compile all .asm to .mem (do not stop on error)"
		echo "clean | delete all output product"
		echo "--help | print this help"
	elif [ $1 = "all" ]
	then
		for filename in *.asm
		do
			echo "Compiling \"${filename}\" ..."
			python ../utils/asm.py -Wall "${filename}" -o "$(basename ${filename} .asm).mem"
		done
	elif [ $1 = "clean" ]
	then
		rm -f *.mem
	else
		echo "Unrecognised command $1"
		echo "See ./compile.sh --help"
	fi
else
	echo "This script require one argument"
	echo "See ./compile.sh --help"
fi
