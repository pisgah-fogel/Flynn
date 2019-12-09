all: bitstream

bitstream: project_script.tcl
	quartus_sh -t project_script.tcl

clean:
	rm -rf simulation/ incremental_db/ output_files/ db/ project_1.*
