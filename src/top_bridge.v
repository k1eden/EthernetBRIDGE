module top_bridge (
phy1100_rx_clk, phy1100_rx_dv, phy1100_rxd, phy1100_rx_err, phy1100_tx_clk, phy1100_tx_en, phy1100_txd, phy1100_tx_err, phy1100_crs, phy1100_col, phy1100_mdio, phy1100_mdc,
phy1200_rx_clk, phy1200_rx_dv, phy1200_rxd, phy1200_rx_err, phy1200_tx_clk, phy1200_tx_en, phy1200_txd, phy1200_tx_err, phy1200_crs, phy1200_col, phy1200_mdio, phy1200_mdc);

input phy1100_rx_clk;
input [3:0] phy1100_rxd;
input phy1100_rx_dv;
input phy1100_rx_err;
input phy1100_tx_clk;
input phy1100_crs;
input phy1100_col;

output phy1100_tx_en;
output [3:0] phy1100_txd;
output phy1100_tx_err;

input phy1100_mdio; 
output phy1100_mdc;

input phy1200_rx_clk;
input [3:0] phy1200_rxd;
input phy1200_rx_dv;
input phy1200_rx_err;
input phy1200_tx_clk;
input phy1200_crs;
input phy1200_col;

output phy1200_tx_en;
output [3:0] phy1200_txd;
output phy1200_tx_err;

input phy1200_mdio; 
output phy1200_mdc;

wire rx_mac_clk_1100;
wire rx_mac_clk_1200;

wire [7:0] data_from_1100;
wire [7:0] data_from_1200;

wire [7:0] data_from_buffer_1200;
wire [7:0] data_from_buffer_1100;

wire empty1100;
wire empty1200;


mac1200 mac1100 (
.phy_rx_clk(phy1100_rx_clk), .phy_rx_dv(phy1100_rx_dv), .phy_rxd(phy1100_rxd), .phy_rx_err(phy1100_rx_err),
.phy_tx_clk(phy1100_tx_clk), .phy_tx_en(phy1100_tx_en), .phy_txd(phy1100_txd), .phy_tx_err(phy1100_tx_err),
.phy_crs(phy1100_crs), .phy_col(phy1100_col), .phy_mdio(phy1100_mdio), .phy_mdc(phy1100_mdc),
.rx_mac_data(data_from_1100), .tx_mac_data(data_from_buffer_1200), .rx_mac_clk(rx_mac_clk_1100)
);

fifo_buff txfifo_1100 (
.clk(rx_mac_clk_1100), .read(!empty1200), .write(1'b1), .data_in(data_from_1100), .data_out(data_from_buffer_1100), .empty(empty1100)
);


fifo_buff txfifo_1200 (
.clk(rx_mac_clk_1200), .read(!empty1100), .write(1'b1), .data_in(data_from_1200), .data_out(data_from_buffer_1200), .empty(empty1200)
);

mac1200 mac1200 (
.phy_rx_clk(phy1200_rx_clk), .phy_rx_dv(phy1200_rx_dv), .phy_rxd(phy1200_rxd), .phy_rx_err(phy1200_rx_err),
.phy_tx_clk(phy1200_tx_clk), .phy_tx_en(phy1200_tx_en), .phy_txd(phy1200_txd), .phy_tx_err(phy1200_tx_err),
.phy_crs(phy1200_crs), .phy_col(phy1200_col), .phy_mdio(phy1200_mdio), .phy_mdc(phy1200_mdc),
.rx_mac_data(data_from_1200), .tx_mac_data(data_from_buffer_1100), .rx_mac_clk(rx_mac_clk_1200)
);

endmodule
