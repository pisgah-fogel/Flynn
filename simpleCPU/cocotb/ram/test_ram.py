import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from cocotb.triggers import FallingEdge

@cocotb.test()
async def test_ram(dut):
    """ Test write/read from RAM when disabled and enables """
    clock = Clock(dut.clk, 10, units="us") # 10us period clock
    cocotb.fork(clock.start())

    dut.addr <= 0b00000000000
    #dut.DI <= 0b000000000
    dut.DI <= 0b111111111
    old_output = dut.DO.value.binstr
    dut.EN <= 0b0 # Disabled chip
    dut.WE <= 0b0
    dut.RE <= 0b0

    await RisingEdge(dut.clk)
    #print("Value = " + dut.DO.value.binstr)
    assert dut.DO.value.binstr == "xxxxxxxxx", "Should not be able to write/read when chip disabled (1 cycle)"
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.DO.value.binstr == "xxxxxxxxx", "Should not be able to write/read when chip disabled (3 cycles)"

    dut.RE <= 0b1
    await RisingEdge(dut.clk)
    assert dut.DO.value.binstr == "xxxxxxxxx", "Should not be able to write when chip disabled, Read enabled (1 cycle)"
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.DO.value.binstr == "xxxxxxxxx", "Should not be able to write when chip disabled, Read enabled (3 cycles)"
    dut.RE <= 0b0
    
    dut.WE <= 0b1
    await RisingEdge(dut.clk)
    assert dut.DO.value.binstr == "xxxxxxxxx", "Should not be able to write when chip disabled, Write enabled (1 cycle)"
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.DO.value.binstr == "xxxxxxxxx", "Should not be able to write when chip disabled, Write enabled (3 cycles)"
    dut.WE <= 0b0

    # Operational error expected
    dut.RE <= 0b1
    dut.WE <= 0b1
    await RisingEdge(dut.clk)
    assert dut.DO.value.binstr == "xxxxxxxxx", "Should not be able to write when chip disabled, Read+Write enabled (1 cycle)"
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.DO.value.binstr == "xxxxxxxxx", "Should not be able to write when chip disabled, Read+Write enabled (3 cycles)"
    dut.RE <= 0b0
    dut.WE <= 0b0
    
    dut.EN <= 0b1 # Enabled chip

    await RisingEdge(dut.clk)
    assert dut.DO.value.binstr == "xxxxxxxxx", "Should not be able to read when read disabled (1 cycle)"
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.DO.value.binstr == "xxxxxxxxx", "Should not be able to read when read disabled (3 cycles)"

    dut.WE <= 0b1
    await RisingEdge(dut.clk)
    assert dut.DO.value.binstr == "xxxxxxxxx", "Should not be able to read when read disabled, Write enabled (1 cycle)"
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.DO.value.binstr == "xxxxxxxxx", "Should not be able to read when read disabled, Write enabled (3 cycles)"
    dut.WE <= 0b0

    dut.DI <= 0b111111111
    dut.WE <= 0b1
    await RisingEdge(dut.clk)
    assert dut.DO.value.binstr == "xxxxxxxxx", "Should not be able to read when read disabled, Write enabled (1 cycle)"
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.DO.value.binstr == "xxxxxxxxx", "Should not be able to read when read disabled, Write enabled (3 cycles)"
    dut.WE <= 0b0
    dut.DI <= 0b000000000

    dut.RE <= 0b1
    assert dut.DO.value.binstr == "xxxxxxxxx", "Expect to read 'x'(previous latched value) just after the memory read is enabled"
    await RisingEdge(dut.clk)
    assert dut.DO.value.binstr == "xxxxxxxxx", "Expect to read 'x'(previous latched value) just after the memory read is enabled"
    await FallingEdge(dut.clk)
    print(dut.DO.value.binstr)
    assert dut.DO.value.binstr == "111111111", "Failed to read previously written datas (1 cycle)"
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.DO.value.binstr == "111111111", "Failed to read previously written datas (3 cycle)"
    dut.RE <= 0b0

    # Operational error expected
    dut.DI <= 0b001000100
    dut.RE <= 0b1
    dut.WE <= 0b1
    await RisingEdge(dut.clk)
    assert dut.DO.value.binstr == "111111111", "Previously written datas expected"
    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)
    assert dut.DO.value.binstr == "001000100", "Failed to read previously written datas (1 cycle after write)"
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.DO.value.binstr == "001000100", "Failed to read previously written datas (3 cycle after write)"
    dut.RE <= 0b0
    dut.WE <= 0b0

    dut.DI <= 0b101000101
    dut.WE <= 0b1
    assert dut.DO.value.binstr == "001000100", "Previously read data should be latched until RE is active again"
    await RisingEdge(dut.clk)
    dut.WE <= 0b0
    assert dut.DO.value.binstr == "001000100", "Should be able reading the old data"
    dut.RE <= 0b1
    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)
    assert dut.DO.value.binstr == "101000101", "Failed to read previously written datas (1 cycle after write)"
    await RisingEdge(dut.clk)
    assert dut.DO.value.binstr == "101000101", "Failed to read previously written datas (2 cycle after write)"
    dut.RE <= 0b0
