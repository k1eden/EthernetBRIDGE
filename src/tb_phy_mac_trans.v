`timescale 1ns/1ps

module tb_phy_mac_trans;

wire phy_rx_clk; // was reg
wire phy_rx_dv; //was reg
wire [3:0] phy_rxd; //was reg
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
reg [7:0] tx_mac_data;
wire rx_mac_clk;
reg tx_mac_valid;
// wire tx_mac_err
reg tx_mac_last;
wire rx_mac_last;
wire rx_mac_valid; //test
wire tx_mac_clk;
wire rx_stat_valid;
wire [26:0] rx_stat_vector;

wire [7:0] data_from_fifo;
wire [7:0] mac_rxd;
reg fifo_full;
reg fifo_empty;
wire last_byte;
reg start;

reg clk;

top_mac_to_fifo_test dut (
.phy_rx_clk(phy_rx_clk),
.phy_rx_dv(phy_rx_dv), 
.phy_rxd(phy_rxd),
.phy_tx_clk(phy_tx_clk), 
.phy_tx_en(phy_tx_en),
.phy_txd(phy_txd), 
.data_from_buff(data_from_fifo), 
.data_from_phy(mac_rxd),
.clk(clk)
);

phy_mii_rx_model u_phy_mii_rx_model(
        .phy_mii_rx_clk_o(phy_rx_clk),
        .phy_mii_rx_dv_o(phy_rx_dv),
        .phy_mii_rxd_o(phy_rxd),
        .speedis1000(1'b0),
        .speedis10(1'b1),
        .start(start)
    );


   initial begin
        clk = 0;
        forever begin
            #10;
            clk = !clk;
        end
    end


   initial begin   
#4
        phy_rx_err = 0;
        phy_crs = 0;
        phy_col = 0;
        reset = 0;
        start = 0;
//        phy_rx_clk = 0;
        phy_tx_clk = 0;
     //   rx_mac_valid = 0;
        forever begin
            #200;
            phy_tx_clk = !phy_tx_clk;

            reset = 1;
  //          phy_crs = 0; 
  //          phy_col = 0; // no useable in FD mod
  //          tx_mac_valid <= 1'b1;
  //          tx_mac_data <= 1'b1;
  //          tx_mac_last <= last_byte;
        end
    end

    initial begin
          
    #100;
        u_phy_mii_rx_model.phy_mii_rx_frame_en(48'h12d146111011,48'h59abcdef1122,1'b0,16'hab12,1'b1,8'h19,16'd99,1'b0,1'b0,16'd0,1'b0,16'h0);//unicast frame 
    //    wait(dut.rx_mac_valid & dut.rx_mac_last & dut.tx_mac_last);  
    #1000
        u_phy_mii_rx_model.phy_mii_rx_frame_en(48'hd2345678aabb,48'h59abcdef1122,1'b0,16'hab12,1'b1,8'h19,16'd100,1'b0,1'b0,16'd0,1'b0,16'h0);

 /*   #100
    start = 1;
    #100
    start = 0; */
    #100000; 
   

$stop;
   
    end

endmodule