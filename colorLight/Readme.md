# Description

My board is a colorLight V8.0
Check [Chubby75's github](https://github.com/q3k/chubby75/blob/master/5a-75b/hardware_V8.0.md) for
the pinout...

# OpenFPGALoader
```
sudo apt install libftdi1-2 libftdi1-dev libhidapi-libusb0 libhidapi-dev libudev-dev cmake
cd /tmp
git clone https://github.com/trabucayre/openFPGALoader.git
cd openFPGALoader
cmake .
make
sudo make install
sudo cp 99-openfpgaloader.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules && sudo udevadm trigger # force udev to take new rule
sudo usermod -a phileas -G plugdev # add user to plugdev group
```
 - Plug in your JTAG programmer
```
sudo dmesg | tail
```
 - Try it:
```
openfpgaloader -d /dev/ttyUSB... --detect
```

Note: If it is not detected and assign to /dev/ttyUSB... you may need to look for
the appriopriate driver.

# Trellis
```
sudo apt install libboost-filesystem-dev libboost-thread-dev libboost-program-options-dev libboost-python-dev
git clone --recursive https://github.com/SymbiFlow/prjtrellis
cd prjtrellis/libtrellis
cmake -DCMAKE_ISNTALL_PREFIX=/usr .
make
sudo make install
```

# Yosys
```
sudo apt install tcl tcl-dev clang libreadline-dev
git clone https://github.com/YosysHQ/yosys
cd yosys
make
sudo make install
```

# Nextpnr
```
sudo apt install libboost-iostreams-dev libqt5opengl5-dev libeigen3-dev
git clone https://github.com/YosysHQ/nextpnr.git
cd nextpnr
cmake -DARCH=ecp5 -DTRELLIS_INSTALL_PREFIX=/usr/ .
make
sudo make install
```

# First test
 - Power the board with 5V
 - plug in the JTAG programmer (do not forget the 3.3V pin - J33)
