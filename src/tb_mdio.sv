`timescale 1ns/1ps

module tb_mdio;

reg clk;
wire mdio;
wire [4:0] miim_phyad;
wire [4:0] miim_regad;
wire [15:0] miim_wrdata;
wire miim_wren;
wire miim_rden;
wire [15:0] miim_rddata;
wire miim_rddata_valid;
wire miim_busy;
wire mdc;
reg start;
reg rstn;

mac_controller dut (
.clk(clk), 
.phy_mdio(mdio),
.miim_phyad(miim_phyad),
.miim_regad(miim_regad),
.miim_wrdata(miim_wrdata),
.miim_wren(miim_wren),
.miim_rden(miim_rden),
.miim_rddata(miim_rddata),
.miim_rddata_valid(miim_rddata_valid),
.miim_busy(miim_busy),
.phy_mdc(mdc),
.reset(rstn)
);

/*phy_conf configurator (
.clk(clk),
.busy(miim_busy),
.phy_add_o(miim_phyad),
.reg_add(miim_regad),
.wr_data(miim_wrdata),
.wren(miim_wren),
.rden(miim_rden),
.start_conf(1'b1)
); */

phy_conf configuratorr (
    .rstn(rstn),
    .clk(clk),             
    .miim_phyad(miim_phyad),        
    .miim_regad(miim_regad),        
    .miim_wrdata(miim_wrdata),       
    .miim_wren(miim_wren),         
    .miim_rden(miim_rden),        
    .busy(miim_busy)
    );


  initial begin
   clk = 0;
   start = 0;
   rstn = 0;
  /*  miim_wren = 0;
    miim_rden = 0;
    miim_phyad = 1'h1;
    miim_regad = 1'h0;
    miim_wrdata = 16'h0;*/
    forever begin
        #20
        clk = !clk;
    end
end

initial begin
#4000
rstn = 1;
/* #3260
miim_wren = 1;
miim_phyad = 1'h1;
miim_regad = 1'h0;
miim_wrdata = 16'b0011000100000000;
#20 
miim_wren = 0;

#69560
miim_phyad = 1'h0;
miim_regad = 1'h1;
miim_wrdata = 16'h0;
#20
miim_rden = 1;
miim_phyad = 5'h1;
miim_regad = 5'h4;
miim_wrdata = 16'b0000000000000000;
#20
miim_rden = 0; */
//#100000
wait(configuratorr.finish_flag);
#100000
$stop;
end

endmodule
