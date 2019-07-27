#!/bin/bash

#
# This script takes no argument
# It search in $TEST_DIR all script that correspond to
# a CPU program in $PROG_DIR
# It runs the HDL simulator to generate the log file
# located in $LOG_PATH corresponding to the CPU program.
# And finaly it executes the test script to check the log file
# if the log file match the expected output it returns 0, else
# returns 0.
#
# Arguments passed to test script:
# 0 - The script name (not usefull)
# 1 - The full path to the assembly file corresponding to the program
# 2 - The full path to the log file containing register status...
#
# Log file format: Log file use a csv like format, run an example
# to see what it looks like.
#

# Relative path from this script dir to CPU's programs and test
PROG_DIR="../programs" # Programs and associated memory are in the same location
TEST_DIR="../tests"
LOG_REPATH="../log.txt" # log relative path
EXE_REPATH="../a.out" # simulation file relative path
ROM_REPATH="../rom.mem"
# CPU's programs, Test Script and memory dump extensions
PROG_EXT="asm"
MEMORY_EXT="mem"
TEST_EXT="py" # by default we use python script for testing
# Program to call when launching a test
TEST_ENGINE="python3"
SIMU_ENGINE="" # simulation engine ("vpp" for verilotor, "" for icarus)

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
LOG_PATH="${SCRIPT_PATH}/${LOG_REPATH}"
EXE_PATH="${SCRIPT_PATH}/${EXE_REPATH}"
ROM_PATH="${SCRIPT_PATH}/${ROM_REPATH}"

if [ ! -f ${EXE_PATH} ]
then
	if [ -r "Makefile" ]
	then
		echo "Build simulation binary and mems"
		make a.out
		make ram.mem
		make rom.mem
	else
		echo "Error: Cannot find $(basename "${EXE_PATH}")"
		exit
	fi
fi

count_missing_tests=0
count_passed_tests=0
count_failed_tests=0
for program in $(ls ${SCRIPT_PATH}/${PROG_DIR}/*.${PROG_EXT})
do
	echo "Program: $(basename "$program")"
	testname="$(basename "$program" ".${PROG_EXT}").py"
	testpath="${SCRIPT_PATH}/${TEST_DIR}/${testname}"
	memory_name="$(basename "$program" ".${PROG_EXT}").${MEMORY_EXT}"
	memory_path="${SCRIPT_PATH}/${PROG_DIR}/${memory_name}"


	if [ ! -r ${memory_path} ]
	then
		echo "Error: No memory $(basename "${memory_name}")"
		echo "This is the product of assembling $(basename "${testname}")"
		exit
	fi
	
	# Launch Simulator
	rm -f ${ROM_PATH} # link rom (CPU program)
	ln -s ${memory_path} ${ROM_PATH}

	${SIMU_ENGINE} ${EXE_PATH} # run simulation
	
	new_log_path="${SCRIPT_PATH}/../$(basename "$program" ".${PROG_EXT}").log"
	if [ ! -r ${LOG_PATH} ]
	then
		echo "Simulation Failed: No log output"
		exit
	else
		mv "${LOG_PATH}" "${new_log_path}"
	fi

	if [ -r "$testpath" ] # test if python script exist
	then
		echo "Test script: ${testname}"
		${TEST_ENGINE} ${testpath} ${program} ${new_log_path}
		status=$?
		if [ ${status} -eq 0 ]
		then
			echo "Test $(basename "$program" ".${PROG_EXT}") returned success(${status}) exit status"
			count_passed_tests=$(($count_passed_tests + 1))
		else
			echo "Test $(basename "$program" ".${PROG_EXT}") returned error(${status}) exit status"
			count_failed_tests=$(($count_failed_tests + 1))
		fi
	else
		echo "Warning: No test script named ${testname}"
		count_missing_tests=$(($count_missing_tests + 1))
	fi
done

echo "Tests done"
echo "${count_missing_tests} Missing; ${count_passed_tests} Success; ${count_failed_tests} Fails"
