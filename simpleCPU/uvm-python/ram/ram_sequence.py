from uvm.seq.uvm_sequence_item import UVMSequenceItem
from uvm.macros import *
from uvm.reg.uvm_reg_adapter import *
from uvm.reg.uvm_reg_model import *
from uvm.base.uvm_object_globals import *

class ram_sequence(UVMSequenceItem):
    """
    A sequence define a type of operation we are going to test on the device
    """
    def __init__(self, name="ram_sequence"):
        super().__init__(name)
        self.addr = 0b00000000000
        self.data_input = 0b111111111
        self.enable = False
        self.write_enable = False
        self.read_enable = True

    def convert2string(self):
        return sv.sformatf("en=%0h we=%0h re=%0h addr=%0h data=%0h",
                self.enable,
                self.write_enable,
                self.read_enable,
                self.addr,
                self.data_input)
    #endclass: ram_sequence
