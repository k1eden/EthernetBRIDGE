module phy_conf (clk, phy_add_o, reg_add, wr_data, wren, busy, rden, start_conf);

input clk;
input busy;
input start_conf;

output reg [4:0] phy_add_o;
output reg [4:0] reg_add;
output reg [15:0] wr_data;
output reg wren;
output reg rden;


// broadcast address
//assign phy_add = 4'b0;

reg process_flag = 1'b0;

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

integer i = 0;

reg finish_flag;

//-------------------------------------------------------------------------------------------------------------

initial begin
    reg_add = 5'h0;
    phy_add_o = 5'h0;
    wr_data = 16'h0;
    wren = 1'b0;
    rden = 1'b0;

    finish_flag = 1'b0;
end

//task conf_adin1300;
//input phy_add_i;

//integer i = 0;
 
 begin

initial begin
sft_rst = 1'b0;

loopback = 1'b0;

speed_sel_lsb = 0; // x1 => 10 or 100 mb/s

autoneg_en = 1;

sft_pd = 0;

isolate = 0;

restart_aneg = 0;

dplx_mode = 1; 

coltest = 0;

speed_sel_msb = 0; // 01 => 100 mb/s

end

   always @(posedge clk)  begin
    if (start_conf && !finish_flag) begin
    case (i)
    
        0: if (!busy) begin
        wren <= 1'b1;
        phy_add_o <= 5'h1;
        //MII_CONTROL REG
        reg_add <= 5'h0;
        wr_data <=  {
                        sft_rst, loopback, speed_sel_lsb, autoneg_en, sft_pd,
                        isolate, restart_aneg, dplx_mode, coltest, speed_sel_msb 
                    };
        i <= i + 1;
    end

        1: begin 
        wren <= 1'b0;
        finish_flag <= 1;
        end
    endcase
end
end
end

endmodule