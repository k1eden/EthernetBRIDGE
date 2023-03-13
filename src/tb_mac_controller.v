`timescale 1ns/1ps

module tb_mac;

reg phy_rx_clk;
reg phy_rx_dv;
reg [3:0] phy_rxd;
reg phy_rx_err;
reg phy_tx_clk;
wire phy_tx_en;
wire [3:0] phy_txd;
// wire phy_tx_err,
reg reset;
// wire mdio_out,
// wire mdio_oen,
reg phy_crs;
reg phy_col;
//wire phy_mdio,
//wire phy_mdc,
wire [7:0] rx_mac_data;
wire [7:0] tx_mac_data;
wire rx_mac_clk;
wire tx_mac_valid;
// wire tx_mac_err
wire tx_mac_last;
wire rx_mac_valid; //test
wire tx_mac_clk;
wire rx_stat_valid;
wire [26:0] rx_stat_vector;

mac_controller dut (
.phy_rx_clk(phy_rx_clk),
.phy_rx_dv(phy_rx_dv),
.phy_rxd(phy_rxd),
.phy_tx_clk(phy_tx_clk),
.phy_tx_en(phy_tx_en),
.phy_txd(phy_txd),
.reset(reset),
.rx_mac_data(rx_mac_data),
.tx_mac_data(tx_mac_data),
.rx_mac_clk(rx_mac_clk),
.tx_mac_valid(tx_mac_valid),
.tx_mac_last(tx_mac_last),
.rx_mac_valid(rx_mac_valid),
.tx_mac_clk(tx_mac_clk),
.phy_crs(phy_crs),
.phy_col(phy_col),
.phy_rx_err(phy_rx_err),
.rx_stat_vector(rx_stat_vector),
.rx_stat_valid(rx_stat_valid)
);

   initial begin   
        phy_rx_err = 0;
        phy_crs = 0;
        phy_col = 1;
        reset = 0;
        phy_rx_clk = 0;
        phy_tx_clk = 0;
     //   rx_mac_valid = 0;
        forever begin
            #20;
            phy_rx_clk = !phy_rx_clk;
            phy_tx_clk = !phy_tx_clk;
            reset = 1;
            phy_crs = 1; 
            phy_col = 0; // no useable in FD mod
     //       rx_mac_valid = 1;
        end
    end

    initial begin
          
    phy_rx_dv = 1'b0;
    phy_rxd = 4'h0;
   
    #40
    phy_rx_dv = 1;
    phy_rxd = 4'h5;


    #560
    phy_rx_dv = 1;
    phy_rxd = 4'hF;
    #40
    phy_rxd = 4'hF;
    #40
    phy_rxd = 4'hF;
    #40
    phy_rxd = 4'hF;
    #40
    phy_rxd = 4'hF;
    #40
    phy_rxd = 4'hF;
    #40
    phy_rxd = 4'hF;
    #40
    phy_rxd = 4'hF;
    #40
    phy_rxd = 4'hF;
    #40
    phy_rxd = 4'hF;
    #40
    phy_rxd = 4'hF;
    #40
    phy_rxd = 4'hF;
    #40
//dest address (01_80_c2_00_00_01)
    phy_rxd = 4'h0;
    #40
    phy_rxd = 4'h1;
    #40
    phy_rxd = 4'h8;
    #40
    phy_rxd = 4'h0;
    #40
    phy_rxd = 4'hc;
    #40
    phy_rxd = 4'h2;
    #40
    phy_rxd = 4'h0;
    #40
    phy_rxd = 4'h0;
    #40
    phy_rxd = 4'h0;
    #40
    phy_rxd = 4'h0;
    #40
    phy_rxd = 4'h0;
    #40
    phy_rxd = 4'h1;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;
#100
    phy_rxd = 4'hA;
#100
    phy_rxd = 4'hd;

    #5000
    $stop;
   
    end

endmodule
