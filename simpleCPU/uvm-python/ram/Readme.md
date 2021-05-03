This is a first attempt at using UVM for RAM verification in simpleCPU.
This does not use Transaction-Level Components (TLC)

## Resource
 - https://github.com/tpoikela/uvm-python/tree/master/test/examples/integrated/ubus/py

## Architecture
### Example
`test_read_modify_write`
	ubus_example_tb
		ubus_example_scoreboard
		ubus_env
			ubus_bus_monitor
				checks
				coverage
			ubus_master_agent
				ubus_master_sequencer
					read_modify_write
					incr_read
					incr_read_write
					seq_r8_w8_r4_w4
					incr_write
				ubus_master_driver
				ubus_master_monitor
					checks
					covergroups
			ubus_slave_agent
				ubus_slave_sequencer
					slave_memory
					simple_response
				ubus_slave_driver
				ubus_slave_monitor
					checks
					covergroups
### My implementation
`test_ram`
	ram_env
		ram_tb
			ram_scoreboard -> sequence (1)
			ram_env
			ram_agent
				ram_sequencer <- sequence (1) -> sequence (2)
				ram_driver <- sequence (2)
				ram_monitor

## Note to myself
Next time start by writing the sequence item: ram_sequence
Then ram_driver
Then ram_monitor
