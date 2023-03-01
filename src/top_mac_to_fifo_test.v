module top_mac_to_fifo_test (phy_rx_clk, phy_rx_dv, phy_rxd, phy_tx_clk, phy_tx_en, phy_txd, phy_mdio, phy_mdc, data_from_buff, data_from_phy);

input phy_rx_clk;
input [3:0] phy_rxd;
input phy_rx_dv; // data valid -- Указывает на действительность данных на phy1100_rxd
input phy_tx_clk;


output phy_tx_en;
output [3:0] phy_txd;


inout phy_mdio; 
output phy_mdc;
wire mdio_out;
wire mdio_oen;

wire empty_phy;
wire rx_mac_clk; 
wire fifo_full;
wire last_byte;

output wire [7:0] data_from_phy;
output wire [7:0] data_from_buff;

assign phy_mdio = (!mdio_oen) ? mdio_out : 1'bz;

/*
phy_conf config_adin1300 (.mdc(phy_mdc))
TODO()
*/
mac_controller mac (
.phy_rx_clk(phy_rx_clk), .phy_rx_dv(phy_rx_dv), .phy_rxd(phy_rxd), .phy_rx_err(phy_rx_err),
.phy_tx_clk(phy_tx_clk), .phy_tx_en(phy_tx_en), .phy_txd(phy_txd), .phy_tx_err(phy_tx_err),
.phy_crs(phy_crs), .phy_col(phy_col), .phy_mdio(phy_mdio), .phy_mdc(phy_mdc), .tx_mac_valid(!empty_phy),
.rx_mac_data(data_from_phy), .tx_mac_data(data_from_buff), .rx_mac_clk(rx_mac_clk), .tx_mac_last(last_byte),
.mdio_out(mdio_out), .mdio_oen(mdio_oen)
);

tx_control last_byte_checker (
.clk(rx_mac_clk), .tx_data(data_from_buff), .tx_data_valid(!empty_phy), .rst(), .last_byte(last_byte)
);

fifo_buff txfifo (
.clk(rx_mac_clk), .read(!empty_phy), .write(1'b1), .data_in(data_from_phy), .data_out(data_from_buff), .empty(empty_phy), .full(fifo_full)
);

endmodule