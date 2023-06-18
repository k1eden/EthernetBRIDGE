# [![Typing SVG](https://readme-typing-svg.herokuapp.com?font=Fira+Code&pause=1000&width=435&lines=EthernetBRIDGE)](https://git.io/typing-svg)

This repository is part of the Bachelor's thesis implementing the 10BASE-TX <--> 10BASE-T1L Ethernet bridging device.

Schematic:

![image](https://github.com/k1eden/EthernetBRIDGE/assets/54855506/18c58eb7-5c56-4d0d-bf4b-d50885351ed9)

* src folder contains a description of the modules that implement the device, as well as the testbench.
* Bridge_test is a ModelSim project that contains a .do script to run the test.

# Modules description
  * top_bridge -- Top lvl module for the bridge
  * top_mac_to_fifo_test --Top lvl module for one PHY configuration
  * tx_control -- Module performing byte-by-byte transmission of a frame to the other side 
  * rx_control -- Module transmitting a pause frame, in case of a buffer overflow threat
  * phy_conf -- Module configuring internal PHY registers
  * mac_controller -- Module configuring the Gowin Triple Speed Ethernet MAC
  * phy_mii_rx_model -- Module simulating data transfer from PHY to MAC
  * pinout_test_board -- Constraint file which maps signals to their physical location on the board

# Running the testbench (ModelSim)
1) Change working folder to Bridge_test
2) Run "do tb.do"
3) Wait until the end of tb to see the result
 
![image](https://github.com/k1eden/EthernetBRIDGE/assets/54855506/18987b64-93d4-4295-a919-50222543493f)

  * * P.S. The main tb is tb_phy_mac_trans.sv, but you can also run other tbs by opening a ModelSim project and clicking on the appropriate file (tb_mdio, tb_mac_controller etc.)
  