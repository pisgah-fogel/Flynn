setmode -bscan
setCable -p auto
identify
assignfile -p 1 -file project_1/top_module.bit
program -p 1
quit
