module phy_conf (clk, phy_add, reg_add, wr_data, wren, busy);

input clk;
input busy;
 
output [4:0] phy_add;
output reg [4:0] reg_add;
output reg [15:0] wr_data;
output reg wren;

 
// broadcast address
assign phy_add = 4'b0;

reg process_flag;

// ------------------------------------------------------------------------------------------------------------- MII CONTROL REG

// Software Reset Bit
reg sft_rst;

// Enable/Disable Loopback Mode
reg loopback;

// The speed selection LSB (Less significant bit)
reg speed_sel_lsb;

// The autonegotiation enable bit. 1: enable autonegotiation process; 0: disable autonegotiation process.
reg autoneg_en;

//Software Power-Down Bit. 0: normal operation.
reg sft_pd;

//solate Bit. 0: normal operation
reg isolate; 

//Restart Autonegotiation Bit. 1: restart aneg process; 0: normal operation
reg restart_aneg;

// Duplex Mode Bit. 1: full
reg dplx_mode;

//Collision Test Bit. 0: disable
reg coltest;

// The speed selection MSB (most significant bit)
reg speed_sel_msb;

// read only bits (UNIDIR_EN, RESERVED)
reg undir_en;
reg [4:0] reserved;

//-------------------------------------------------------------------------------------------------------------

initial 
begin
sft_rst = 1'b0;

loopback = 1'b0;

speed_sel_lsb = 1; // x1 => 10 or 100 mb/s

autoneg_en = 1;

sft_pd = 0;

isolate = 0;

restart_aneg = 0;

dplx_mode = 1; 

coltest = 0;

speed_sel_msb = 0; // 01 => 100 mb/s

end

always@(posedge clk) 
begin
    //MII_CONTROL REG
    reg_add = 5'h0;

    wren = 1'b0;

    if (reg_add == 5'h0 && process_flag == 1'b0 && !busy)
        begin
        process_flag = 1'b1;
        wren = 1'b1;
        wr_data = {
                    sft_rst, loopback, speed_sel_lsb, autoneg_en, sft_pd,
                    isolate, restart_aneg, dplx_mode, coltest, speed_sel_msb 
                  };
        process_flag = 1'b0;
        end
  
    


end

endmodule