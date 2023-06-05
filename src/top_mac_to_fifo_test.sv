/* 
 THIS MODULE IS THE TOP-LEVEL FILE FOR DEBUGING PROJECT WITH 1 PHY CONFIGURATION
*/
module top_mac_to_fifo_test (clk, phy_rx_clk, phy_rx_dv, phy_rxd, phy_tx_clk, phy_tx_en, phy_txd, phy_mdio, phy_mdc, phy_reset, data_from_buff, data_from_phy);

input phy_rx_clk;
input [3:0] phy_rxd;
input phy_rx_dv; // data valid -- Указывает на действительность данных на phy1100_rxd
input phy_tx_clk;

output phy_tx_en;
output [3:0] phy_txd;


inout phy_mdio; 
output phy_mdc;

output reg phy_reset;

wire mdio_out;
wire mdio_oen;

wire empty_phy;
wire rx_mac_clk; 
wire tx_mac_clk;
wire fifo_full;
wire last_byte;
wire rx_mac_valid;
reg reset_mac;


input clk;
wire [4:0] miim_phyad;
wire [4:0] miim_regad;
wire [15:0] miim_wrdata;
wire miim_wren;
wire miim_rden;

wire [15:0] miim_rddata;
wire miim_rddata_valid;
wire miim_busy;

wire tx_pause_req;
wire [15:0] tx_pause_val;
wire [47:0] tx_pause_source_addr;
wire tx_valid_flag;
wire [15:0] frm_len;
wire tx_mac_valid;
wire tx_valid_control;
wire [26:0] rx_stat_vector;
wire rx_stat_valid;
wire nextByte;
wire nextLen;

wire empty_len;



output wire [7:0] data_from_phy;
output wire [7:0] data_from_buff;

wire [7:0] tx_control_data;

logic fifo_buff_almost_full;

assign phy_mdio = (!mdio_oen) ? mdio_out : 1'bz;
assign tx_mac_valid = tx_valid_control;


/*always @(posedge rx_stat_valid)
 frm_len <= rx_stat_vector [21:6] - 16'd4;
*/
initial begin
    reset_mac = 1'b0; // 0 is active lvl
    phy_reset = 1'b0;
//    frm_len = 16'h0;
end

logic [7:0] start_cnt = 8'h0;
logic start_flag = 1'b0;

always_ff @(posedge clk) begin
    if (start_cnt < 8'hff)   
            start_cnt <= start_cnt + 1'b1;  
    
    if (start_cnt == 8'hff) start_flag <= 1'b1;  
                else start_flag <= 1'b0;    
end

always @(posedge clk) 
    if (start_flag) begin 
        reset_mac <= 1'b1;
        phy_reset <= 1'b1;
    end else begin
        reset_mac <= 1'b0;
        phy_reset <= 1'b0;
    end
phy_conf #(5'h0) configurator (
    .rstn(reset_mac),
    .clk(/*phy_mdc*/clk),
    .busy(miim_busy),

    .miim_phyad(miim_phyad),
    .miim_regad(miim_regad),
    .miim_wrdata(miim_wrdata),
    .miim_wren(miim_wren),
    .miim_rden(miim_rden)
  
); //10 mb/s + full duplex + autoneg on


mac_controller mac (
    .phy_rx_clk(phy_rx_clk),
    .phy_rx_dv(phy_rx_dv),
    .phy_rxd(phy_rxd),
    .phy_rx_err(phy_rx_err),
    .phy_tx_clk(phy_tx_clk),
    .phy_tx_en(phy_tx_en),
    .phy_txd(phy_txd),
    .phy_tx_err(phy_tx_err),
    .phy_crs(phy_crs),
    .phy_col(phy_col),
    .phy_mdio(phy_mdio),
    .phy_mdc(phy_mdc),
    .tx_mac_valid(tx_mac_valid),
    .rx_mac_data(data_from_phy),
    .tx_mac_data(tx_control_data),
    .rx_mac_clk(rx_mac_clk),
    .tx_mac_clk(tx_mac_clk),
    .tx_mac_ready(tx_mac_ready), 
    .tx_mac_last(last_byte),
    .mdio_out(mdio_out),
    .mdio_oen(mdio_oen),
    .clk(clk),
    .miim_phyad(miim_phyad), 
    .miim_regad(miim_regad),
    .miim_wrdata(miim_wrdata),
    .miim_wren(miim_wren),
    .miim_rden(miim_rden),
    .rx_mac_last(rx_mac_last),
    .miim_rddata(miim_rddata),
    .miim_rddata_valid(miim_rddata_valid),
    .miim_busy(miim_busy),
    .rx_mac_valid(rx_mac_valid),
    .reset(reset_mac),
    .tx_pause_req(tx_pause_req),
    .tx_pause_val(tx_pause_val),
    .tx_pause_source_addr(tx_pause_source_addr),
    .rx_stat_vector(rx_stat_vector),
    .rx_stat_valid(rx_stat_valid)
);

tx_control controller (
    .clk(tx_mac_clk),
    .tx_data(data_from_buff),
    .tx_data_valid(tx_valid_flag),
    .rst(reset_mac),
    .last_byte(last_byte),
    .tx_data_o(tx_control_data),
    .valid_flag(tx_valid_control),
    .tx_mac_ready(tx_mac_ready),
    .frm_len(frm_len),
    .nextByte(nextByte),
    .empty_buff(empty_phy),
    .rx_frame(rx_stat_valid),
    .nextLen(nextLen),
    .empty_len_buff(empty_len)
);

rx_control fifo_overflow_control (
    .tx_clk(tx_mac_clk),
    .tx_pause_source_addr_r(tx_pause_source_addr),
    .is_fifo_full(fifo_buff_almost_full),
    .tx_pause_req(tx_pause_req),
    .tx_pause_val(tx_pause_val),
    .rstn(reset_mac),
    .rx_dv(rx_mac_valid)
);

fifo_buff rxfifo (
    .clk(rx_mac_clk), 
    .read(!empty_phy && nextByte),
    .write(rx_mac_valid),
    .data_in(data_from_phy),
    .data_out(data_from_buff),
    .empty(empty_phy),
    .full(fifo_full),
    .rst_n(reset_mac),
    .tx_valid_flag(tx_valid_flag),
    .rx_mac_last(rx_mac_last), 
    .almost_full(fifo_buff_almost_full)
);

fifo_buff #(16) rx_frm_len_fifo  (
    .clk(rx_mac_clk),
    .read(!empty_len && nextLen),
    .write(rx_stat_valid),
    .data_in(rx_stat_vector [21:6] - 16'd4),
    .data_out(frm_len),
    .empty(empty_len),
    .rst_n(reset_mac)
);

endmodule