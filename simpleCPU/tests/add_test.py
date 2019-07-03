#!/bin/python3

#
# This script is called by utils/launch_test.sh
# it exit(0) when success else exit(0)
#

import sys

# sys.argv[0]: Script name
# sys.argv[1]: Assembly file
# sys.argv[2]: Log file

# Use this function to check the design
# Arguments:
# - dic_step: contains dictionnary with values of
#   r0...r7 FE FG FL C and PC registers
# Return:
# - True if et matches the expected values,
#   Else False
non_reset_pc = "ffff"
non_reset_pc_int = 0xffff

def check_step(dic_step):
    global non_reset_pc
    global non_reset_pc_int
    if non_reset_pc_int == 0xffff: # we are still in reset or non on stable state
        if dic_step["r0"] != "00" and dic_step["r0"] != "zz":
            non_reset_pc = dic_step["PC"]
            non_reset_pc_int = int(non_reset_pc, 16)
            print("Found non reset: %s" % str(non_reset_pc))
        else:
            return True
    if non_reset_pc_int != 0xffff:
        offset = int(dic_step["PC"], 16) - non_reset_pc_int

        if offset == 0:
            if dic_step["r0"] == "07":
                return True
            else:
                return False
        elif offset == 1:
            if dic_step["r1"] == "07":
                return True
            else:
                return False
        elif offset == 2:
            if dic_step["r0"] == "08":
                return True
            else:
                return False
        elif offset == 3:
            if dic_step["r0"] == "0f":
                print("0x07 + 0x08 passed")
                return True
            else:
                return False
        else:
            print("Offset %d:" % (offset))
            print(dic_step)
            return False
    

if len(sys.argv) != 3:
    print("Error: Expect 3 arguments")
    print("Look at utils/launch_tests.sh for more information")
    exit(1) # Error

match_asm = False

with open(sys.argv[2]) as logfile:
    first_line = logfile.readline().strip()
    keys = first_line.split(",")
    line_count=0
    for line in logfile:
        line_count += 1
        splitted = line.strip().split(',')
        if len(splitted) != len(keys):
            print("Error in log.txt on line %d" % line_count)
            print("len(splitted) = %d" % len(splitted))
            print("len(keys) = %d" % len(keys))
            print("Splitted = %s" % splitted)
            exit(1) # Format error in log.txt

        dic_line = {}
        for i in range(len(splitted)):
            dic_line[keys[i]] = splitted[i]

        if not check_step(dic_line):
            exit(1) # Do not match expected values

    exit(0) # Success

exit(1) # Reach only if there was an IO error
