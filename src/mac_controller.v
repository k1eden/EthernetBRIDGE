module mac_controller (
phy_rx_clk, phy_rx_dv, phy_rxd, phy_rx_err, phy_tx_clk, phy_tx_en, phy_txd, phy_tx_err, phy_crs, phy_col, phy_mdio, phy_mdc, rx_mac_data, tx_mac_data, rx_mac_clk, tx_mac_valid, tx_mac_err);

input phy_rx_clk;
input [3:0] phy_rxd;
input phy_rx_dv;
input phy_rx_err;
input phy_tx_clk;
input phy_crs;
input phy_col;

output phy_tx_en;
output [3:0] phy_txd;
output phy_tx_err;

//----------------------------------------------------------------------------------------------------------------------------- MII interface

//Inputs
wire reset; 

input tx_mac_valid; 
input [7:0] tx_mac_data; 
wire tx_mac_last; 
input wire tx_mac_err; 

//Outputs
wire tx_mac_clk;
output rx_mac_clk;
wire rx_mac_valid;
output wire [7:0] rx_mac_data;
wire rx_mac_last;
wire rx_mac_err;
wire tx_mac_ready;

wire tx_collision;
wire tx_retransmit;

wire rx_stat_valid;
wire [26:0] rx_stat_vector;
wire tx_stat_valid;
wire [28:0] tx_stat_vector;

//----------------------------------------------------------------------------------------------------------------------------- User interface

input phy_mdio; 

output phy_mdc;
wire mdio_out;
wire mdio_oen;

//----------------------------------------------------------------------------------------------------------------------------- Managment interface (input)

wire speed1000 = 0;  // if 1 - speed = 1000, else speed = 10/100 

wire speed10 = 1; // if 1 - speed = 10, else 100

wire duplex_stat = 0; // if 0 = full duplex, else half duplex

//----------------------------------------------------------------------------------------------------------------------------- Interface status configure

Triple_Speed_Ethernet_MAC_Top mac_controller (
.mii_rx_clk(phy_rx_clk), .mii_rxd(phy_rxd), .mii_rx_dv(phy_rx_dv), .mii_rx_er(phy_rx_err), .mii_tx_clk(phy_tx_clk), .mii_txd(phy_txd),
.mii_tx_en(phy_tx_en), .mii_tx_er(phy_tx_err), .mii_col(phy_col), .mii_crs(phy_crs), .duplex_status(duplex_stat), .rstn(reset), .rx_mac_clk(rx_mac_clk),
.rx_mac_valid(rx_mac_valid), .rx_mac_data(rx_mac_data), .rx_mac_last(rx_mac_last), .rx_mac_error(rx_mac_err), .rx_statistics_valid(rx_stat_valid),
.rx_statistics_vector(rx_stat_vector), . tx_mac_clk(tx_mac_clk), .tx_mac_valid(tx_mac_valid), .tx_mac_data(tx_mac_data), .tx_mac_last(tx_mac_last),
.tx_mac_error(tx_mac_err), .tx_mac_ready(tx_mac_ready), .tx_collision(tx_collision), .tx_retransmit(tx_retransmit), .tx_statistics_valid(tx_stat_valid),
.tx_statistics_vector(tx_stat_vector), .mdc(phy_mdc), .mdio_in(phy_mdio), .mdio_out(mdio_out), .mdio_oen(mdio_oen)
);

endmodule
