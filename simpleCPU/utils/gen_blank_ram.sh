#!/bin/bash

#
# This script generated a ram memory file for simulation
# The output file contains only zeros (9*2048 zeros)
#

if [ $# -eq 1 ]
then
	python -c "print(('0'*9+'\n')*2048)" >> $1
else
	echo "This script expect one argument: the output file name"
fi
