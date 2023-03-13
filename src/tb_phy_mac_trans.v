`timescale 1ns/1ps

module tb_phy_mac_trans;

reg clk;
reg phy_rx_clk;
reg phy_rx_dv;
reg [3:0] phy_rxd;
reg phy_tx_clk;
wire phy_tx_en;
wire [3:0] phy_txd;
wire phy_mdio;
wire phy_mdc;
wire [7:0] data_from_buff;
wire [7:0] data_from_phy;

top_mac_to_fifo_test dut (
    .clk(clk),
    .phy_rx_clk(phy_rx_clk),
    .phy_rx_dv(phy_rx_dv),
    .phy_rxd(phy_rxd),
    .phy_tx_clk(phy_tx_clk),
    .phy_tx_en(phy_tx_en),
    .phy_txd(phy_txd),
    .phy_mdio(phy_mdio),
    .phy_mdc(phy_mdc),
    .data_from_buff(data_from_buff),
    .data_from_phy(data_from_phy)
);

   initial begin
        clk = 0;
        phy_rx_clk = 0;
        phy_tx_clk = 0;
        forever begin
            #20;
            clk = !clk;
            phy_rx_clk = !phy_rx_clk;
            phy_tx_clk = !phy_tx_clk;
        end
    end


    initial begin
    phy_rx_dv = 1'b0;
    phy_rxd = 4'h0;
    
    #100
    phy_rx_dv = 1;
    phy_rxd = 4'h1;
    #100
    phy_rx_dv = 0;
    #100
    phy_rx_dv = 1;
    phy_rxd = 4'h2;
    #100
    phy_rx_dv = 0;
    #100
    phy_rx_dv = 1;
    phy_rxd = 4'h3;
    #100
    phy_rx_dv = 0;

    $stop;
    end

endmodule