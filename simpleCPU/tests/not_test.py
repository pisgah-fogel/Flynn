#!/bin/python2

#
# This script is called by utils/launch_test.sh
# it exit(0) when success else exit(0)
#

import sys
# sys.argv[0]: Script name
# sys.argv[1]: Assembly file
# sys.argv[2]: Log file

import test_framework

if len(sys.argv) != 3:
    print("Error: Expect 3 arguments")
    print("Look at utils/launch_tests.sh for more information")
    exit(1) # Error

expected = test_framework.load_csv("tests/not_test.csv")
array_all = test_framework.load_csv(sys.argv[2])

if not test_framework.check_all(array_all, expected):
    exit(1) # Do not match expected values
else:
    exit(0) # Success

