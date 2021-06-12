from uvm.base import sv
from uvm.comps import UVMScoreboard
from uvm.macros import uvm_component_utils, uvm_info
from uvm.tlm1 import UVMAnalysisImp

class ram_scoreboard(UVMScoreboard):
    """
    Compare signals from the DUT to a reference and give it a score
    (PASS / FAIL)
    """

    def __init__(self, name, parent):
        UVMScoreboard.__init__(self, name, parent)
    
    def build_phase(self, phase):
        pass

    def write(self, trans):
        # TODO
