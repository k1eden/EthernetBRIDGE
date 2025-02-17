/* 
 THIS MODULE IS RESPONSIBLE FOR CONFIGURING MAC-CONTROLLER IP-CORE
*/
module mac_controller (
phy_rx_clk, phy_rx_dv, phy_rxd, phy_rx_err, phy_tx_clk, phy_tx_en, phy_txd, phy_tx_err, reset, mdio_out, mdio_oen,
phy_crs, phy_col, phy_mdio, phy_mdc, rx_mac_data, tx_mac_data, rx_mac_clk, tx_mac_valid, tx_mac_err, tx_mac_last, miim_wren,
miim_rden, miim_wrdata, miim_regad, miim_phyad, miim_rddata_valid, miim_busy, miim_rddata, clk, rx_mac_valid, tx_mac_clk,
rx_stat_valid, rx_stat_vector, tx_pause_req, tx_pause_val, tx_pause_source_addr, rx_mac_last, tx_mac_ready);

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

//-----------------------------------------------------------------------------------------------------------------------------MIIM interface
input clk;
input [4:0] miim_phyad;
input [4:0] miim_regad;
input [15:0] miim_wrdata;
input miim_wren;
input miim_rden;

output [15:0] miim_rddata;
output miim_rddata_valid;
output miim_busy;


//----------------------------------------------------------------------------------------------------------------------------- MII interface

//Inputs
input wire reset; 

input tx_mac_valid; 
input [7:0] tx_mac_data; 
input wire tx_mac_last; 
input wire tx_mac_err; 

//Outputs
output tx_mac_clk;
output rx_mac_clk;
output rx_mac_valid;
output wire [7:0] rx_mac_data;
output rx_mac_last;
wire rx_mac_err;
output tx_mac_ready;

wire tx_collision;
wire tx_retransmit;

output rx_stat_valid;
output [26:0] rx_stat_vector;
wire tx_stat_valid;
wire [28:0] tx_stat_vector;

//----------------------------------------------------------------------------------------------------------------------------- User interface

inout phy_mdio; 

output phy_mdc;
output mdio_out;
output mdio_oen;

assign phy_mdio = (!mdio_oen) ? mdio_out : 1'bz;

//----------------------------------------------------------------------------------------------------------------------------- Managment interface (input)

wire speed1000 = 0;  // if 1 - speed = 1000, else speed = 10/100 

wire speed10 = 1; // if 1 - speed = 10, else 100

wire duplex_stat = 0; // if 0 = full duplex, else half duplex

//----------------------------------------------------------------------------------------------------------------------------- Interface status configure

input tx_pause_req;
input [15:0] tx_pause_val;
input [47:0] tx_pause_source_addr;
wire rx_pause_req;
wire [15:0] rx_pause_val;
//----------------------------------------------------------------------------------------------------------------------------- IP Configure

Triple_Speed_Ethernet_MAC_Top mac_controller (
.mii_rx_clk(phy_rx_clk), .mii_rxd(phy_rxd), .mii_rx_dv(phy_rx_dv), .mii_rx_er(phy_rx_err), .mii_tx_clk(phy_tx_clk), .mii_txd(phy_txd),
.mii_tx_en(phy_tx_en), .mii_tx_er(phy_tx_err), .mii_col(phy_col), .mii_crs(phy_crs), .duplex_status(duplex_stat), .rstn(reset), .rx_mac_clk(rx_mac_clk),
.rx_mac_valid(rx_mac_valid), .rx_mac_data(rx_mac_data), .rx_mac_last(rx_mac_last), .rx_mac_error(rx_mac_err), .rx_statistics_valid(rx_stat_valid),
.rx_statistics_vector(rx_stat_vector), .tx_mac_clk(tx_mac_clk), .tx_mac_valid(tx_mac_valid), .tx_mac_data(tx_mac_data), .tx_mac_last(tx_mac_last),
.tx_mac_error(/*tx_mac_err*/1'b0), .tx_mac_ready(tx_mac_ready), .tx_collision(tx_collision), .tx_retransmit(tx_retransmit), .tx_statistics_valid(tx_stat_valid),
.tx_statistics_vector(tx_stat_vector), .mdc(phy_mdc), .mdio_in(phy_mdio), .mdio_out(mdio_out), .mdio_oen(mdio_oen), .clk(clk), .miim_phyad(miim_phyad),
.miim_regad(miim_regad),
.miim_wrdata(miim_wrdata),
.miim_wren(miim_wren),
.miim_rden(miim_rden),
.miim_rddata(miim_rddata),
.miim_rddata_valid(miim_rddata_valid),
.miim_busy(miim_busy),
.tx_pause_req(tx_pause_req),
.tx_pause_val(tx_pause_val),
.tx_pause_source_addr(tx_pause_source_addr),
.tx_fcs_fwd_ena(1'b0), //auto fcs 
.rx_fcs_fwd_ena(1'b0),
.tx_ifg_delay_ena(1'b0),
.tx_ifg_delay(8'h0),
.rx_jumbo_ena(1'b0),
.rx_pause_req(rx_pause_req),
.rx_pause_val(rx_pause_val)
);

endmodule
