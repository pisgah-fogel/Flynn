## First Step

### Block design

- Zynq7 Processing System
- Processor System Reset
- AXI Interconnect
- AXI GPIO (connected to LED)

### Synthesis, Implementation and export

- Click Generate Bitstream
- Tools > Export > Export Block Design..., `.../project_1/design_1.tcl`
- `cp project_1/project_1.runs/impl_1/design_1_wrapper.bit project_1/design_1.bit`
- `cp project_1/project_1.srcs/sources_1/bd/design_1/hw_handoff/design_1.hwh project_1/`

### Move to the board

- Power on the board
- Connect it trough ethernet
- Use manual config for local network
- `scp project_1/design_1.* xilinx@192.168.2.99:~/pynq/overlays/design_1/` (Password: xilinx)

### Use it
- `ssh xilinx@192.168.2.99`
- Run python3 with super user permission
```python
from pynq import Overlay
overlay = Overlay('design_1.bit')
gpio = overlay.ip_dict['axi_gpio_0']

from pynq.lib import AxiGPIO
leds = AxiGPIO(gpio).channel1

```