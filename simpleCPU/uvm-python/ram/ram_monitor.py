
import cocotb
from cocotb.triggers import *

from uvm.base.uvm_callback import *
from uvm.comps.uvm_monitor import UVMMonitor
from uvm.tlm1 import *
from uvm.macros import *

from .ram_sequence import *

class ram_monitor(UVMMonitor):
    """
    Monitor fetches datas from the DUT and transfer it to the
    scoreboard for comparison to the reference model
    """
    
    def __init__(self, name, parent=None):
        UVMMonitor.__init__(self, name, parent)
        self.ap = UVMAnalysisPort("ap", self)
        self.sigs = None # Passive
        self.cfg = None
        self.errors = 0
        self.num_items = 0
        self.tags = "RAM_MONITOR"

    def build_phase(self, phase):
        super().build_phase(phase)
        agent = self.get_parent()
        if agent is not None:
            self.sigs = agent.vif
        else:
            array = []
            if UVMConfigDb.get(self, "", "vif", array):
                uvm_info("RAM/MON/NOVIF", "Got vif from ConfigDb for RAM Monitor instance")
                self.sigs = array[0]
            if self.sigs is None:
                uvm_fatal("RAM/MON/NOVIF", "No virtual interface specified in ConfigDb")

    async def run_phase(self, phase):
        while True:
            tr = None

            # Building a sequence item fron the DUT's outputs
            tr = ram_sequence.type_id.create("tr", self)

            # Sample delay
            await RisingEdge(self.sigs.clk)
            await Timer(1, "NS")

            tr.addr = self.sigs.addr.value.integer
            tr.data_input = self.sigs.DI.value.integer
            tr.enable = self.sigs.EN.value.integer
            tr.write_enable = self.sigs.WE.value.integer
            tr.read_enable = self.sigs.RE.value.integer
            
            # Can check for error:
            #self.errors += 1
            #uvm_error("RAM/MON", "Protocol violation: RE and WE enabled at the same time")
            self.num_items += 1
            self.ap.write(tr)
            uvm_info(self.tag, "Sampled RAM item: "+tr.convert2string(), UVM_HIGH)

uvm_component_utils(ram_monitor)
