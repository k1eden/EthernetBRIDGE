`timescale 1ns/1ps

module tb_mac;

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
reg tx_mac_err;
reg tx_mac_last;
wire rx_mac_last;
wire rx_mac_valid; //test
wire tx_mac_clk;
wire rx_stat_valid;
wire [26:0] rx_stat_vector;
wire tx_mac_ready;

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
.tx_mac_err(tx_mac_err),
.rx_mac_valid(rx_mac_valid),
.tx_mac_clk(tx_mac_clk),
.phy_crs(phy_crs),
.phy_col(phy_col),
.phy_rx_err(phy_rx_err),
.rx_stat_vector(rx_stat_vector),
.rx_stat_valid(rx_stat_valid),
.rx_mac_last(rx_mac_last),
.tx_mac_ready(tx_mac_ready)
);

phy_mii_rx_model u_phy_mii_rx_model(
        .phy_mii_rx_clk_o(phy_rx_clk),
        .phy_mii_rx_dv_o(phy_rx_dv),
        .phy_mii_rxd_o(phy_rxd),
        .speedis1000(1'b0),
        .speedis10(1'b1)
    );

mac_mii_tx_model u_mac_mii_tx_model(
    //    .mac_mii_tx_clk_o(tx_mac_clk),
    //    .mac_mii_tx_dv_o(tx_mac_valid),
    //    .mac_mii_txd_o(tx_mac_data)
    //    .speedis1000(1'b0),
    //    .speedis10(1'b1)
    );

   initial begin   
        phy_rx_err = 0;
        phy_crs = 0;
        phy_col = 1;
        reset = 0;
        tx_mac_data <= 8'h0;
//        phy_rx_clk = 0;
        phy_tx_clk = 0;
     //   rx_mac_valid = 0;
            tx_mac_valid = 0;
        forever begin
            #200;
  //          phy_rx_clk = !phy_rx_clk;
            phy_tx_clk = !phy_tx_clk;
        //    reset = 1;
            phy_crs = 0; 
            phy_col = 0; // no useable in FD mod
     //       rx_mac_valid = 1;
        end
    end

    initial begin
  //    #100;
  //      u_mac_mii_tx_model.start_tx_test(tx_mac_ready);
     #2000
        reset = 1'b1;
     #4800
        tx_mac_data = 8'h11;
        tx_mac_valid = 1'b1;
        wait(dut.tx_mac_ready)
        tx_mac_data = 8'h12;
 //  #100;
 //       u_phy_mii_rx_model.phy_mii_rx_frame_en(48'hd23456781a1b/*48'hd2345678aabb*/,48'h59abcdef1122,1'b0, 16'ha/*1'b1,16'hab12*/,1'b1,8'h19,16'd100,1'b0,1'b0,16'd0,1'b0,16'h0);//unicast frame
 //      wait(dut.rx_mac_valid & dut.rx_mac_last);
 //  $stop;
    #100; 
        tx_mac_err <= 0;
        tx_mac_last <= 0;
     //   tx_mac_valid <= 1;
     //   tx_mac_data <= 8'h1;
    #2000;
/*        tx_mac_valid <= 1;
        tx_mac_data <= 8'h11;
    wait(dut.tx_mac_ready);
    #100;
        tx_mac_data <= 8'hab;
    #100;
        tx_mac_data <= 8'hcd;
    #100;
        tx_mac_data <= 8'hef;
    #100;
        tx_mac_data <= 8'h11;
    #100;
        tx_mac_data <= 8'h22;
    #100;
        tx_mac_data <= 8'hd2;
    #100;
        tx_mac_data <= 8'h34;
    #100;
        tx_mac_data <= 8'h56;
    #100;
        tx_mac_data <= 8'h78;
    #100;
        tx_mac_data <= 8'h1a;
    #100;
        tx_mac_data <= 8'h1b;
    #100;
        tx_mac_data <= 8'ha;
    #100;
        tx_mac_data <= 8'h5;
    #100;
        tx_mac_data <= 8'ha;
    #100;
        tx_mac_data <= 8'h5;
    #100;
        tx_mac_data <= 4'ha;
    #100;
        tx_mac_data <= 4'h5;
    #100;
        tx_mac_data <= 4'ha;
    #100;
        tx_mac_data <= 4'h5;
    #100;
        tx_mac_data <= 4'ha;
    #100;
        tx_mac_data <= 4'h5;
    #100;
        tx_mac_data <= 4'ha;
    #100;
        tx_mac_data <= 4'h5;
    #100;
        tx_mac_data <= 4'ha;
    #100;
        tx_mac_data <= 4'h5;
    #100;
        tx_mac_data <= 4'ha;
    #100;
        tx_mac_data <= 4'h5;
    #100;
        tx_mac_data <= 4'ha;
    #100;
        tx_mac_data <= 4'h5;
    #100;
        tx_mac_data <= 4'ha;
    #100;
        tx_mac_data <= 4'h5;
    #100;
        tx_mac_data <= 4'ha;
    #100;
        tx_mac_data <= 4'h5;
    #100;
        tx_mac_data <= 4'ha;
    #100;
        tx_mac_data <= 4'h5;
    #100;
        tx_mac_data <= 4'ha;
    #100;
        tx_mac_data <= 4'h5;
    #100;
        tx_mac_data <= 4'ha;
    #100;
        tx_mac_data <= 4'h5;
    #100;
        tx_mac_data <= 4'ha;
    #100;
        tx_mac_data <= 4'h5;
    #100;
        tx_mac_data <= 4'ha;
    #100;
        tx_mac_data <= 4'h5;
    #100;
        tx_mac_data <= 4'ha;
    #100;
        tx_mac_data <= 4'h5;
    #100;
        tx_mac_data <= 4'ha;
    #100;
        tx_mac_data <= 4'h5;
    #100;
        tx_mac_data <= 4'ha;
    #100;
        tx_mac_data <= 4'h5;
    #100;
        tx_mac_data <= 4'ha;
    #20;
        tx_mac_data <= 4'h5;
    #20;
        tx_mac_data <= 4'ha;
    #20;
        tx_mac_data <= 4'h5;
    #20;
        tx_mac_data <= 4'ha;
    #20;
        tx_mac_data <= 4'h5;
    #20;
        tx_mac_data <= 4'h5;
    #20;
        tx_mac_data <= 4'h5;
    #20;
        tx_mac_data <= 4'h5;
    #20;
        tx_mac_data <= 4'h5;
    #20;
        tx_mac_data <= 4'h5;
    #20;
        tx_mac_data <= 4'h5;
    #20;
        tx_mac_data <= 4'h5;
    #20;
        tx_mac_data <= 4'h5;
    #20;
        tx_mac_data <= 4'h5;
    #20;
        tx_mac_data <= 4'h5;
    #20;
        tx_mac_data <= 4'h5;
    #20;
        tx_mac_data <= 4'h5;
    #20;
        tx_mac_data <= 4'hd;
    #20;
        tx_mac_data <= 4'h2;
    #20;
        tx_mac_data <= 4'hd;
    #20;
        tx_mac_data <= 4'h4;
    #20;
        tx_mac_data <= 4'h3;
    #20;
        tx_mac_data <= 4'h6;
    #20;
        tx_mac_data <= 4'h5;
#20;
        tx_mac_data <= 4'h8;
#20;
        tx_mac_data <= 4'h7;
#20;
        tx_mac_data <= 4'ha;
#20;
        tx_mac_data <= 4'ha;
#20;
        tx_mac_data <= 4'hb;
#104;
        tx_mac_data <= 4'hb;
        tx_mac_last <= 1'b1;
        
#100
        tx_mac_last <= 1'b0;
        tx_mac_valid <= 0;  
#50000; */
 /*   
    begin
    for (i = 0; i < 14; i = i+1)
    @(posedge phy_rx_clk)
    phy_rxd = 4'h5;
    phy_rx_dv = 1'b1;
    @(negedge phy_rx_clk)
    phy_rxd = 4'h5;
    phy_rx_dv = 1'b1;
    end
    @(posedge phy_rx_clk)
    phy_rxd = 4'h5;
    phy_rx_dv = 1'b1;
    @(negedge phy_rx_clk)
    phy_rxd = 4'h5;
    phy_rx_dv = 1'b1;
    @(posedge phy_rx_clk);
    phy_rx_dv <= 1'b1;
    phy_rxd <= 4'hd;
    @(negedge phy_rx_clk);
    phy_rx_dv <= 1'b1;
    phy_rxd <= 4'hd;
    

    for (i = 0; i < 77; i = i+1)
    @posedge(phy_rx_clk);
    case (i)
    0: begin
       phy_rxd <= 4'h2; 
       phy_rx_dv <= 1'b1;
       end
    1: begin
       phy_rxd <= 4'hd; 
       phy_rx_dv <= 1'b1;
       end
    2: begin
       phy_rxd <= 4'h4; 
       phy_rx_dv <= 1'b1;
       end
    3: begin
       phy_rxd <= 4'h3; 
       phy_rx_dv <= 1'b1;
       end
    4: begin
       phy_rxd <= 4'h6; 
       phy_rx_dv <= 1'b1;
       end
    5: begin
       phy_rxd <= 4'h5; 
       phy_rx_dv <= 1'b1;
       end
    6: begin
       phy_rxd <= 4'h8; 
       phy_rx_dv <= 1'b1;
       end
    7: begin
       phy_rxd <= 4'h7; 
       phy_rx_dv <= 1'b1;
       end
    8: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    9: begin
       phy_rxd <= 4'h1; 
       phy_rx_dv <= 1'b1;
       end
    10: begin
       phy_rxd <= 4'hb; 
       phy_rx_dv <= 1'b1;
       end
    11: begin
       phy_rxd <= 4'h1; 
       phy_rx_dv <= 1'b1;
       end
// dest.address

    12: begin
       phy_rxd <= 4'h2; 
       phy_rx_dv <= 1'b1;
       end
    13: begin
       phy_rxd <= 4'h2; 
       phy_rx_dv <= 1'b1;
       end
    14: begin
       phy_rxd <= 4'h2; 
       phy_rx_dv <= 1'b1;
       end
    15: begin
       phy_rxd <= 4'h2; 
       phy_rx_dv <= 1'b1;
       end
    16: begin
       phy_rxd <= 4'h2; 
       phy_rx_dv <= 1'b1;
       end
    17: begin
       phy_rxd <= 4'h2; 
       phy_rx_dv <= 1'b1;
       end
    18: begin
       phy_rxd <= 4'h2; 
       phy_rx_dv <= 1'b1;
       end
    19: begin
       phy_rxd <= 4'h2; 
       phy_rx_dv <= 1'b1;
       end
    20: begin
       phy_rxd <= 4'h2; 
       phy_rx_dv <= 1'b1;
       end
    21: begin
       phy_rxd <= 4'h2; 
       phy_rx_dv <= 1'b1;
       end
    22: begin
       phy_rxd <= 4'h2; 
       phy_rx_dv <= 1'b1;
       end
    23: begin
       phy_rxd <= 4'h2; 
       phy_rx_dv <= 1'b1;
       end
// source.address

    24: begin
       phy_rxd <= 4'h0; 
       phy_rx_dv <= 1'b1;
       end
    25: begin
       phy_rxd <= 4'h4; 
       phy_rx_dv <= 1'b1;
       end
// data.len

    26: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    27: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    28: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    29: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    30: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    31: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    32: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    33: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    34: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    35: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    36: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    37: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    38: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    39: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    40: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    41: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    42: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    43: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    44: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    45: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    46: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    47: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    48: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    49: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    50: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    51: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    52: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    53: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    54: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    55: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    56: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    57: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    58: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    59: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    60: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    61: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    62: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    63: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    64: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    65: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    66: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    67: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    68: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    69: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    70: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    71: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    72: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
// data

    73: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    74: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    75: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
    76: begin
       phy_rxd <= 4'ha; 
       phy_rx_dv <= 1'b1;
       end
// CRC
    endcase
*/
    $stop;
   
    end

endmodule
