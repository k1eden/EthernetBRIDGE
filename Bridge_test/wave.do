onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_phy_mac_trans/dut/controller/clk
add wave -noupdate /tb_phy_mac_trans/dut/controller/tx_mac_ready
add wave -noupdate /tb_phy_mac_trans/dut/controller/valid_flag
add wave -noupdate -radix hexadecimal /tb_phy_mac_trans/dut/controller/tx_data_o
add wave -noupdate -radix decimal /tb_phy_mac_trans/dut/controller/pointer
add wave -noupdate /tb_phy_mac_trans/dut/controller/nextByte
add wave -noupdate -radix decimal /tb_phy_mac_trans/dut/controller/frm_len
add wave -noupdate /tb_phy_mac_trans/dut/mac/tx_mac_last
add wave -noupdate /tb_phy_mac_trans/dut/mac/phy_tx_en
add wave -noupdate -radix hexadecimal /tb_phy_mac_trans/dut/mac/phy_txd
add wave -noupdate -radix hexadecimal /tb_phy_mac_trans/dut/mac/rx_mac_data
add wave -noupdate -radix hexadecimal /tb_phy_mac_trans/phy_rxd
add wave -noupdate /tb_phy_mac_trans/phy_rx_dv
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {510200000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 285
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {167139738 ps}
