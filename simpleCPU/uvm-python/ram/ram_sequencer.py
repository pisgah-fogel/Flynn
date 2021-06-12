from uvm.seq.uvm_sequencer import UVMSequencer
from uvm.macros import uvm_component_utils

class ram_sequencer(UVMSequencer): # ram_sequence
    
    def __init__(self, name, parent=None):
        UVMSequencer.__init__(self, name, parent)

uvm_component_utils(ram_sequencer)
