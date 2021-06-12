import cocotb
from cocotb.triggers import *

from uvm.base.uvm_callback import *
from uvm.base.uvm_config_db import *
from uvm.comps.uvm_driver import UVMDriver
from uvm.macros import *

from .ram_sequence import *

class ram_driver(UVMDriver):
    """
    Is in charge of driving the Unit Under Test (ram)
    """
    def __init__(self, name, parent=None):
        UVMDriver.__init__(self, name, parent)
        self.trig = Event("trans_exec")
        self.sigs = None # Will fetch it from the Agent in build_phase
        self.cfg = None # Config
        self.tag = "RAM_DRIVER"

    def build_phase(self, phase):
        super().build_phase(phase)
        agent = self.get_parent()
        if agent is not None:
            self.sigs = agent.vif # Get the signals from the Agent
        else:
            array = []
            if (not UVMConfigDb.get(self, "", "vif", array)):
                uvm_fatal("RAM/DRV/NOVIF", "No virtual interface specified for self driver instance")
            else:
                uvm_info("RAM/DRV/NOVIF", "Got vif from ConfigDb for RAM Driver instance")
                self.sigs = array[0]

    async def run_phase(self, phase):
        uvm_info("RAM_DRIVER", "ram_driver run_phase started", UVM_MEDIUM)

        self.sigs.addr <= 0b00000000000 # dut.addr
        self.sigs.DI <= 0b111111111
        self.sigs.EN <= 0b0
        self.sigs.WE <= 0b0
        self.sigs.RE <= 0b0

        while True:
            #await RisingEdge(self.sigs.clk)

            tr = []
            # Get a transaction from the sequencer
            # Bidir port of uvm_driver
            # Include standard TLM methods: get() peek(), put()
            await self.seq_item_port.get_next_item(tr)
            tr = tr[0]
            uvm_info("RAM_DRIVER", "Driving: "+tr.convert2string(), UVM_DEBUG)

            await Timer(1, "NS") # Drive delay

            await Timer(1, "NS") # Waiting for Transaction to be received

            # Driving DUT according to the sequenceItem tr
            if tr.enable == False:
                self.sigs.EN <= 0b0
            else:
                self.sigs.EN <= 0b1
            if tr.write_enable == False:
                self.sigs.WE <= 0b0
            else:
                self.sigs.RE <= 0b1
            if tr.read_enable == False:
                self.sigs.RE <= 0b0
            else:
                self.sigs.RE <= 0b1
            self.sigs.addr <= tr.addr
            self.sigs.DI <= tr.data_input

            await RisingEdge(self.sigs.clk)

            await Timer(1, "NS") # Waiting for the transaction to be executed

            self.seq_item_port.item_done()
            self.trig.set()
        # endtask: run_phase

uvm_component_utils(ram_driver)
