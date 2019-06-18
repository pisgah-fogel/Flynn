#!/usr/bin/python3
import sys

if len(sys.argv) == 1:
	print("Nothing to do")
	exit()

outputfile = "a.out"
inputfile = ""
warnings = False

def reg_to_bin(string):
	if string == "r0":
		return "000"
	elif string == "r1":
		return "001"
	elif string == "r2":
		return "010"
	elif string == "r3":
		return "011"
	elif string == "r4":
		return "100"
	elif string == "r5":
		return "101"
	elif string == "r6":
		return "110"
	elif string == "r7":
		return "111"
	else:
		print("Error: %s in an invalid register" % string)
		exit()
		return ""

def is_bin(string):
	for letter in string:
		if letter != "0" and letter != "1":
			return False
	return True

def addr_to_bin(string):
	if is_bin(string) and len(string) == 8:
		return string
	else:
		print("Error: %s is not a valid address" % string)
		exit()
		return ""

isfirst = True
isinputset = False
isoutput = False
isoutputset = False
count = 0
for arg in sys.argv:
	count = count + 1
	if count == 1:
		continue
	if isoutput:
		outputfile = arg
		isoutputset = True
		isoutput = False
	elif arg == "-Wall":
		warnings = True
	elif arg == "-o":
		if isoutputset:
			exit()
		isoutput = True
	else:
		if isinputset:
			exit()
		inputfile = arg
		isinputset = True

try:
	with open(inputfile, "r") as f:
		output = []
		data = f.readlines()
		for line in data:
			words = line.split()
			if words[0] == "LD":
				output.append(addr_to_bin(words[1]) + "1")
			elif words[0] == "MOV":
				output.append(reg_to_bin(words[1]) + reg_to_bin(words[2]) + "100")
			elif words[0] == "CMP":
				output.append(reg_to_bin(words[1]) + reg_to_bin(words[2]) + "110")
			elif words[0] == "JE":
				output.append("000001000")
			elif words[0] == "JG":
				output.append("000011000")
			elif words[0] == "JL":
				output.append("000101000")
			elif words[0] == "JMP":
				output.append("000111000")
			elif words[0] == "ADD":
				output.append("001001000")
			elif words[0] == "AND":
				output.append("001011000")
			elif words[0] == "OR":
				output.append("001101000")
			elif words[0] == "NOT":
				output.append("001111000")
			elif words[0] == "XOR":
				output.append("010001000")
			elif words[0] == "LDR":
				output.append("010011000")
			elif words[0] == "STR":
				output.append("010101000")
			elif words[0] == "NOP":
				output.append("010111000")
			else:
				print("No instruction %s" % words[0])
				exit()
		print("Done")
		print("%d instructions" % len(output))
		print("%d bits" % (len(output)*9))

		with open(outputfile, "w") as outfile:
			for inst in output:
				outfile.write(inst+"\n")
			for i in range(0, 2048-len(output)):
				outfile.write("000000000\n")
			print("Saved to %s" % outputfile)
		
except FileNotFoundError:
	print("File %s not found" % inputfile)
