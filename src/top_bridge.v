/* 
 THIS MODULE IS THE TOP-LEVEL MODULE FOR SPE <--> ETHERNET BRIDGE
*/
module top_bridge (
    clk, phy_rx_clk_1100, phy_rx_dv_1100, phy_rxd_1100, phy_tx_clk_1100, phy_tx_en_1100, phy_txd_1100, phy_mdio_1100, phy_mdc_1100,
         phy_rx_clk_1300, phy_rx_dv_1300, phy_rxd_1300, phy_tx_clk_1300, phy_tx_en_1300, phy_txd_1300, phy_mdio_1300, phy_mdc_1300    
);

input phy_rx_clk_1100;
input [3:0] phy_rxd_1100;
input phy_rx_dv_1100; // data valid -- Указывает на действительность данных на phy1100_rxd
input phy_tx_clk_1100;

input phy_rx_clk_1300;
input [3:0] phy_rxd_1300;
input phy_rx_dv_1300; // data valid -- Указывает на действительность данных на phy1100_rxd
input phy_tx_clk_1300;



output phy_tx_en_1100;
output [3:0] phy_txd_1100;

output phy_tx_en_1300;
output [3:0] phy_txd_1300;


inout phy_mdio_1100; 
output phy_mdc_1100;

inout phy_mdio_1300; 
output phy_mdc_1300;

wire mdio_out_1100;
wire mdio_oen_1100;

wire mdio_out_1300;
wire mdio_oen_1300;

wire empty_phy_1100;
wire rx_mac_clk_1100; 
wire tx_mac_clk_1100;
wire fifo_full_1100;
wire last_byte_1100;
wire rx_mac_valid_1100;

wire empty_phy_1300;
wire rx_mac_clk_1300; 
wire tx_mac_clk_1300;
wire fifo_full_1300;
wire last_byte_1300;
wire rx_mac_valid_1300;

reg reset_mac;


input clk;

wire [4:0] miim_phyad_1100;
wire [4:0] miim_regad_1100;

wire [4:0] miim_phyad_1300;
wire [4:0] miim_regad_1300;

wire [15:0] miim_wrdata_1100;
wire miim_wren_1100;

wire [15:0] miim_wrdata_1300;
wire miim_wren_1300;

wire miim_rden_1100;
wire [15:0] miim_rddata_1100;
wire miim_rddata_valid_1100;
wire miim_busy_1100;

wire miim_rden_1300;
wire [15:0] miim_rddata_1300;
wire miim_rddata_valid_1300;
wire miim_busy_1300;

wire tx_pause_req_1100;
wire [15:0] tx_pause_val_1100;
wire [47:0] tx_pause_source_addr_1100;

wire tx_pause_req_1300;
wire [15:0] tx_pause_val_1300;
wire [47:0] tx_pause_source_addr_1300;

wire tx_valid_flag_1100;
reg [15:0] frm_len_1100;
wire tx_mac_valid_1100;
wire tx_valid_control_1100;

wire tx_valid_flag_1300;
reg [15:0] frm_len_1300;
wire tx_mac_valid_1300;
wire tx_valid_control_1300;

wire [26:0] rx_stat_vector_1100;
wire rx_stat_valid_1100;

wire [26:0] rx_stat_vector_1300;
wire rx_stat_valid_1300;

wire nextByte_1100;
wire nextByte_1300;


wire [7:0] data_from_phy_1100;
wire [7:0] data_from_buff_1100;

wire [7:0] data_from_phy_1300;
wire [7:0] data_from_buff_1300;

wire [7:0] tx_control_data_1100;
wire [7:0] tx_control_data_1300;

assign phy_mdio_1100 = (!mdio_oen_1100) ? mdio_out_1100 : 1'bz;
assign tx_mac_valid_1100 = tx_valid_control_1100;

assign phy_mdio_1300 = (!mdio_oen_1300) ? mdio_out_1300 : 1'bz;
assign tx_mac_valid_1300 = tx_valid_control_1300;

always @(posedge rx_stat_valid_1100)
 frm_len_1100 <= rx_stat_vector_1100 [21:6] - 16'd4;

always @(posedge rx_stat_valid_1300)
 frm_len_1300 <= rx_stat_vector_1300 [21:6] - 16'd4;

initial begin
    reset_mac = 1'b1; // 0 is active lvl
    frm_len_1100 = 16'h0;
    frm_len_1300 = 16'h0;
end

phy_conf configurator_1100 (
    .clk(phy_mdc_1100),
    .phy_add_o(miim_phyad_1100),
    .reg_add(miim_regad_1100),
    .wr_data(miim_wrdata_1100),
    .wren(miim_wren_1100),
    .busy(miim_busy_1100)
); //100 mb/s + full duplex + autoneg on

phy_conf configurator_1300 (
    .clk(phy_mdc_1300),
    .phy_add_o(miim_phyad_1300),
    .reg_add(miim_regad_1300),
    .wr_data(miim_wrdata_1300),
    .wren(miim_wren_1300),
    .busy(miim_busy_1300)
); //100 mb/s + full duplex + autoneg on


mac_controller mac_1100 (
    .phy_rx_clk(phy_rx_clk_1100),
    .phy_rx_dv(phy_rx_dv_1100),
    .phy_rxd(phy_rxd_1100),
    .phy_rx_err(phy_rx_err_1100),

    .phy_tx_clk(phy_tx_clk_1100),
    .phy_tx_en(phy_tx_en_1100),
    .phy_txd(phy_txd_1100),
    .phy_tx_err(phy_tx_err_1100),

    .phy_crs(phy_crs_1100),
    .phy_col(phy_col_1100),

    .phy_mdio(phy_mdio_1100),
    .phy_mdc(phy_mdc_1100),

    .tx_mac_valid(tx_mac_valid_1100),
    .rx_mac_data(data_from_phy_1100),
    .tx_mac_data(tx_control_data_1100),
    .rx_mac_clk(rx_mac_clk_1100),
    .tx_mac_clk(tx_mac_clk_1100),
    .tx_mac_ready(tx_mac_ready_1100), 
    .tx_mac_last(last_byte_1100),
    .rx_mac_last(rx_mac_last_1100),

    .mdio_out(mdio_out_1100),
    .mdio_oen(mdio_oen_1100), 

    .clk(clk),
    .miim_phyad(miim_phyad_1100), 
    .miim_regad(miim_regad_1100),
    .miim_wrdata(miim_wrdata_1100),
    .miim_wren(miim_wren_1100),
    .miim_rden(miim_rden_1100),
    .miim_rddata(miim_rddata_1100),
    .miim_rddata_valid(miim_rddata_valid_1100),
    .miim_busy(miim_busy_1100),
    .rx_mac_valid(rx_mac_valid_1100),
    .reset(reset_mac),
    .tx_pause_req(tx_pause_req_1100),
    .tx_pause_val(tx_pause_val_1100),
    .tx_pause_source_addr(tx_pause_source_addr_1100),
    .rx_stat_vector(rx_stat_vector_1100),
    .rx_stat_valid(rx_stat_valid_1100)
);

mac_controller mac_1300 (
    .phy_rx_clk(phy_rx_clk_1300),
    .phy_rx_dv(phy_rx_dv_1300),
    .phy_rxd(phy_rxd_1300),
    .phy_rx_err(phy_rx_err_1300),

    .phy_tx_clk(phy_tx_clk_1300),
    .phy_tx_en(phy_tx_en_1300),
    .phy_txd(phy_txd_1300),
    .phy_tx_err(phy_tx_err_1300),

    .phy_crs(phy_crs_1300),
    .phy_col(phy_col_1300),

    .phy_mdio(phy_mdio_1300),
    .phy_mdc(phy_mdc_1300),

    .tx_mac_valid(tx_mac_valid_1300),
    .rx_mac_data(data_from_phy_1300),
    .tx_mac_data(tx_control_data_1300),
    .rx_mac_clk(rx_mac_clk_1300),
    .tx_mac_clk(tx_mac_clk_1300),
    .tx_mac_ready(tx_mac_ready_1300), 
    .tx_mac_last(last_byte_1300),
    .rx_mac_last(rx_mac_last_1300),

    .mdio_out(mdio_out_1300),
    .mdio_oen(mdio_oen_1300), 

    .clk(clk),
    .miim_phyad(miim_phyad_1300), 
    .miim_regad(miim_regad_1300),
    .miim_wrdata(miim_wrdata_1300),
    .miim_wren(miim_wren_1300),
    .miim_rden(miim_rden_1300),
    .miim_rddata(miim_rddata_1300),
    .miim_rddata_valid(miim_rddata_valid_1300),
    .miim_busy(miim_busy_1300),
    .rx_mac_valid(rx_mac_valid_1300),
    .reset(reset_mac),
    .tx_pause_req(tx_pause_req_1300),
    .tx_pause_val(tx_pause_val_1300),
    .tx_pause_source_addr(tx_pause_source_addr_1300),
    .rx_stat_vector(rx_stat_vector_1300),
    .rx_stat_valid(rx_stat_valid_1300)
);

fifo_buff rxfifo_1100 (
    .clk(rx_mac_clk_1100),
    .read(!empty_phy_1100 && nextByte_1100),
    .write(rx_mac_valid_1100),
    .data_in(data_from_phy_1100),
    .data_out(data_from_buff_1100),
    .empty(empty_phy_1100),
    .full(fifo_full_1100),
    .rst_n(reset_mac),
    .tx_valid_flag(tx_valid_flag_1100),
    .rx_mac_last(rx_mac_last_1100) 
);

fifo_buff rxfifo_1300 (
    .clk(rx_mac_clk_1300),
    .read(!empty_phy_1300 && nextByte_1300),
    .write(rx_mac_valid_1300),
    .data_in(data_from_phy_1300),
    .data_out(data_from_buff_1300),
    .empty(empty_phy_1300),
    .full(fifo_full_1300),
    .rst_n(reset_mac),
    .tx_valid_flag(tx_valid_flag_1300),
    .rx_mac_last(rx_mac_last_1300) 
);

tx_control controller_1100 (
    .clk(/*tx_mac_ready*/ tx_mac_clk_1100),
    .tx_data(data_from_buff_1300),
    .tx_data_valid(/*tx_mac_valid*/ tx_valid_flag_1100),
    .rst(1'b1),
    .last_byte(last_byte_1100),
    .tx_data_o(tx_control_data_1100),
    .valid_flag(tx_valid_control_1100),
    .tx_mac_ready(tx_mac_ready_1100),
    .frm_len(frm_len_1300),
    .nextByte(nextByte_1100),
    .empty_buff(empty_phy_1300)
);

tx_control controller_1300 (
    .clk(/*tx_mac_ready*/ tx_mac_clk_1300),
    .tx_data(data_from_buff_1100),
    .tx_data_valid(/*tx_mac_valid*/ tx_valid_flag_1300),
    .rst(1'b1),
    .last_byte(last_byte_1300),
    .tx_data_o(tx_control_data_1300),
    .valid_flag(tx_valid_control_1300),
    .tx_mac_ready(tx_mac_ready_1300),
    .frm_len(frm_len_1100),
    .nextByte(nextByte_1300),
    .empty_buff(empty_phy_1100)
);


rx_control fifo_overflow_control_1100 (
    .tx_clk(tx_mac_clk_1100),
    .tx_pause_source_addr_r(tx_pause_source_addr_1100),
    .is_fifo_full(fifo_full_1100),
    .tx_pause_req(tx_pause_req_1100),
    .tx_pause_val(tx_pause_val_1100)
);

rx_control fifo_overflow_control_1300 (
    .tx_clk(tx_mac_clk_1300),
    .tx_pause_source_addr_r(tx_pause_source_addr_1300),
    .is_fifo_full(fifo_full_1300),
    .tx_pause_req(tx_pause_req_1300),
    .tx_pause_val(tx_pause_val_1300)
);

endmodule