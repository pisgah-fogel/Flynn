all: button.bit

program: button.bit
	openFPGALoader -d /dev/ttyUSB0 -cdigilent button.bit

program-flash: button.bit
	openFPGALoader -d /dev/ttyUSB0 button.bit -f

button.bit: button.config
	ecppack button.config button.bit

button.config: button.json button.lpf
	nextpnr-ecp5 --25k --package CABGA256 --speed 6 --json button.json --textcfg button.config --lpf button.lpf --freq 25

button.json: button.v
	yosys -p "synth_ecp5 -json button.json" button.v

clean:
	rm -f button.json button.bit button.config
