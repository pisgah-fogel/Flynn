from uvm.comps.uvm_agent import UVMAgent
from uvm.base import UVMConfigDb
from uvm.macros import *
from uvm.tlm1 import *

from .ram_monitor import ram_monitor
from .ram_driver import ram_driver
from .ram_sequencer import ram_sequencer
from .ram_sequence import ram_sequence

class ram_agent(UVMAgent):

    def __init__(self, name, parent=None):
        super().__init__(name, parent)
        self.sqr = None # ram_sequencer
        self.drv = None # ram_driver
        self.mon = None # ram_monitor
        self.vif = None
        self.error = False

    def build_phase(self, phase):
        self.sqr = ram_sequencer.type_id.create("sqr", self)
        self.drv = ram_driver.type_id.create("drv", self)
        self.mon = ram_monitor.type_id.create("mon", self)
        
        arr = []
        if UVMConfigDb.get(self, "", "vif", arr):
            self.vif = arr[0]
        if self.vif is None:
            uvm_fatal("RAM/AGT/NOVIF", "No virtual interface speficied")

    def connect_phase(self, phase):
        # Connect Driver to Sequencer
        self.drv.seq_item_port.connect(self.sqr.seq_item_export)

    def extract_phase(self, phase):
        if self.mon.errors > 0:
            self.error = True
        if self.mon.num_items == 0:
            uvm_error("RAM/AGT", "Ram monitor did not get any item")
            self.error = True

uvm_component_utils(ram_agent)
