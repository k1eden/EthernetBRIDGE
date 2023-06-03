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
wire tx_mac_last;
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

reg [31:0] fcs_1frame;
reg [31:0] fcs_2frame;
reg [31:0] fcs_3frame;

reg clk;

localparam [31:0] rx_fcs_1frame = 32'h93_36_e2_83;
localparam [31:0] rx_fcs_2frame = 32'h8b_31_03_f5;
localparam [31:0] rx_fcs_3frame = 32'h93_36_e2_83;

integer i;

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
            #20;
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
        fcs_1frame = 32'h0;
        fcs_2frame = 32'h0;
        fcs_3frame = 32'h0;
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
    wait(dut.reset_mac);
    $timeformat(-9, 2, "ns");      
    #100;
        $display("--------------%0t:rx first frame-------------------",$realtime);
        u_phy_mii_rx_model.phy_mii_rx_frame_en(48'h12d146111011,48'h59abcdef1122,1'b0,16'hab12,1'b1,8'h19,16'd99,1'b0,1'b0,16'd0,1'b0,16'h0);//unicast frame 
        wait(dut.last_byte);
        repeat (8) @(posedge phy_tx_clk);
       // wait(dut.phy_txd == 4'h3);
        
        @(posedge phy_tx_clk); fcs_1frame[3:0] = dut.phy_txd;
        @(posedge phy_tx_clk); fcs_1frame[7:4] = dut.phy_txd;
        @(posedge phy_tx_clk); fcs_1frame[11:8] = dut.phy_txd;    
        @(posedge phy_tx_clk); fcs_1frame[15:12] = dut.phy_txd;
        @(posedge phy_tx_clk); fcs_1frame[19:16] = dut.phy_txd;
        @(posedge phy_tx_clk); fcs_1frame[23:20] = dut.phy_txd;
        @(posedge phy_tx_clk); fcs_1frame[27:24] = dut.phy_txd;
        @(posedge phy_tx_clk); fcs_1frame[31:28] = dut.phy_txd;    
        

         
        
    //    wait(dut.rx_mac_valid & dut.rx_mac_last & dut.tx_mac_last);  
    #1000;
        $display("--------------%0t:rx second frame-------------------",$realtime);
        u_phy_mii_rx_model.phy_mii_rx_frame_en(48'hd2345678aabb,48'h59abcdef1122,1'b0,16'hab12,1'b1,8'h19,16'd64,1'b0,1'b0,16'd0,1'b0,16'h0);
        wait(dut.last_byte);
        repeat (8) @(posedge phy_tx_clk);
       
        @(posedge phy_tx_clk); fcs_2frame[3:0] = dut.phy_txd;
        @(posedge phy_tx_clk); fcs_2frame[7:4] = dut.phy_txd;
        @(posedge phy_tx_clk); fcs_2frame[11:8] = dut.phy_txd;    
        @(posedge phy_tx_clk); fcs_2frame[15:12] = dut.phy_txd;
        @(posedge phy_tx_clk); fcs_2frame[19:16] = dut.phy_txd;
        @(posedge phy_tx_clk); fcs_2frame[23:20] = dut.phy_txd;
        @(posedge phy_tx_clk); fcs_2frame[27:24] = dut.phy_txd;
        @(posedge phy_tx_clk); fcs_2frame[31:28] = dut.phy_txd;

       // wait(dut.phy_rx_dv);
        wait(dut.phy_tx_en);
        $display("--------------%0t:tx first frame-------------------",109404);
//        wait(dut.last_byte);
//        wait(!dut.phy_tx_en);
        wait(dut.phy_tx_en);
        $display("--------------%0t:tx second frame-------------------",$realtime);

 /*   #100
    start = 1;
    #100
    start = 0; */
    #150000; 
    $display("--------------%0t:rx third frame-------------------",$realtime);
    u_phy_mii_rx_model.phy_mii_rx_frame_en(48'h12d146111011,48'h59abcdef1122,1'b0,16'hab12,1'b1,8'h19,16'd99,1'b0,1'b0,16'd0,1'b0,16'h0);//unicast frame
    wait(dut.last_byte);
    repeat (8) @(posedge phy_tx_clk);
       
        @(posedge phy_tx_clk); fcs_3frame[3:0] = dut.phy_txd;
        @(posedge phy_tx_clk); fcs_3frame[7:4] = dut.phy_txd;
        @(posedge phy_tx_clk); fcs_3frame[11:8] = dut.phy_txd;    
        @(posedge phy_tx_clk); fcs_3frame[15:12] = dut.phy_txd;
        @(posedge phy_tx_clk); fcs_3frame[19:16] = dut.phy_txd;
        @(posedge phy_tx_clk); fcs_3frame[23:20] = dut.phy_txd;
        @(posedge phy_tx_clk); fcs_3frame[27:24] = dut.phy_txd;
        @(posedge phy_tx_clk); fcs_3frame[31:28] = dut.phy_txd;
    //wait(dut.phy_rx_dv);
    wait(dut.phy_tx_en);
    $display("--------------%0t:tx third frame-------------------",$realtime);
    
    #150000; 
    
    $display("--------------FCS CHECK...-------------------");
   
    $monitor("first tx frame FCS = %h         second tx frame FCS = %h          third tx frame FCS = %h         first rx frame FCS = %h          second rx frame FCS = %h           third rx frame FCS = %h", 
                fcs_1frame,                        fcs_2frame,                         fcs_3frame,                       rx_fcs_1frame,                      rx_fcs_2frame,                       rx_fcs_3frame   );
    if (fcs_1frame == rx_fcs_1frame && fcs_2frame == rx_fcs_2frame && fcs_3frame == rx_fcs_3frame) $display("--------------TEST PASSED-------------------");
    else $display("--------------TEST FAILED-------------------");
    
    #150000; 
$stop;
   
    end

endmodule