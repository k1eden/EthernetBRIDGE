#quit -sim

#OnFinish = {stop}

vlib work  

#mapping work library to current directory
#vmap [-help] [-c] [-del] [<logical_name>] [<path>]
vmap work  

#compile all .v files to work library
#-work <path>       Specify library WORK
#-vlog01compat      Ensure compatibility with Std 1364-2001
#-incr              Enable incremental compilation
#"rtl/*.v"          rtl directory all .v files, support relative path, need to add ""
#vlog
vlog -work work -incr "prim_sim_h.v"
vlog -work work -incr "prim_sim.v"
vlog -work work -incr ../src/mac_controller.sv
vlog -work work -incr ../src/phy_mii_rx_model.sv
vlog -work work -incr ../src/rx_control.sv
vlog -work work -incr ../src/tb_phy_mac_trans.sv
vlog -work work -incr ../src/top_mac_to_fifo_test.sv
vlog -work work -incr ../src/tx_control.sv


#simulate testbench top file
#-L <libname>                     Search library for design units instantiated from Verilog and for VHDL default component binding
#+nowarn<CODE | Number>           Disable specified warning message  (Example: +nowarnTFMPC)                      
#-t [1|10|100]fs|ps|ns|us|ms|sec  Time resolution limit VHDL default: resolution setting from .ini file) 
#                                 (Verilog default: minimum time_precision in the design)
#-novopt                          Force incremental mode (pre-6.0 behavior)
vsim -L work -novopt -onfinish stop -classdebug tb_phy_mac_trans

#generate wave log format(WLF)......
#log -r /*

#open wave window
view wave

#add simulation singals
do wave.do

#set simulation time
run  -all



