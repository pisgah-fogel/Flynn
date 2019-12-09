all: bitstream

bitstream: project_script.tcl
	quartus_sh -t project_script.tcl

program:
	quartus_pgm -l # List of harware
	quartus_pgm -c <TODO: Cable name> -a # List of devices
	quartus_pgm -c <TODO: Cable name> <TODO: Bitstream name>.cdf
	

clean:
	rm -rf simulation/ incremental_db/ output_files/ db/ project_1.*
