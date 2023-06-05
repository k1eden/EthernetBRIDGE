/* 
 THIS MODULE IS RESPONSIBLE FOR CONFIGURING THE INTERNAL PHY REGISTERS
*/
module phy_conf #(parameter phyad = 5'b00000) (
    rstn, clk, busy, miim_phyad, miim_regad, miim_wrdata, miim_wren, miim_rden         
    );
    
    input           rstn;
    input           clk;    
    input           busy;

    output  reg [4:0]  miim_phyad;     
    output  reg [4:0]  miim_regad;        
    output  reg [15:0]  miim_wrdata;       
    output  reg miim_wren;         
    output  reg miim_rden;

    logic [7:0] start_cnt;
    logic start_flag;
    logic finish_flag;
    
    typedef enum logic [2:0] {
        s_idle = 3'd0,
        s_prep = 3'd1,
        s_readReg = 3'd2,
        s_writeConf = 3'd3,
        s_wait = 3'd4
} conf_state;

    conf_state state = s_idle;

    logic rw_reg;
    reg [4:0] phy_address_reg;
    reg [4:0] reg_address_reg;
    reg [15:0] wrdata_reg;
    
    reg [7:0] op_cnt;

    /*
// ------------------------------------------------------------------------------------------------------------- MII CONTROL REG

// Software Reset Bit [15]


// Enable/Disable Loopback Mode [14]


// The speed selection LSB (Less significant bit) [13]


// The autonegotiation enable bit. 1: enable autonegotiation process; 0: disable autonegotiation process. [12]


// Software Power-Down Bit. 0: normal operation. [11]


// solate Bit. 0: normal operation [10]


// Restart Autonegotiation Bit. 1: restart aneg process; 0: normal operation [9]


// Duplex Mode Bit. 1: full [8]


// Collision Test Bit. 0: disable [7]


// The speed selection MSB (most significant bit) [6]


// read only bits (UNIDIR_EN, RESERVED) [5]

// RESERVED [4:0]

    */
    
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            rw_reg <= 1'b0;
            phy_address_reg <= 5'b0;
            reg_address_reg <= 5'b0;
            wrdata_reg <= 16'b0;
        end
        else begin
            if (state == s_idle && start_flag & !finish_flag) begin
                if (op_cnt == 8'd0) begin  // write to CONTROL REGISTER 10Mbit/s + full duplex
                    rw_reg <= 1'b1;
                    phy_address_reg <= phyad;
                    reg_address_reg <= 5'h0;
                    wrdata_reg <= 16'h44;
                end
                else if (op_cnt == 8'd1) begin  // read ID REG (should be 0x0283)
                    rw_reg <= 1'b0;
                    phy_address_reg <= phyad;
                    reg_address_reg <= 5'h2;
                    wrdata_reg <= 16'h0;
                end
                else if (op_cnt == 8'd2) begin // read CONTROL REGISTER
                    rw_reg <= 1'b0;
                    phy_address_reg <= phyad;
                    reg_address_reg <= 5'h0;
                end          
           end
        end
    end
    
    always_ff @(posedge clk or negedge rstn) begin  // configure delay
        if (!rstn) begin
            start_cnt <= 8'd0;
            start_flag <= 1'd0;
        end
        else begin
            if (start_cnt < 8'hff) begin  
                start_cnt <= start_cnt + 1'b1;
            end
            if (start_cnt == 8'hff) begin
                start_flag <= 1'b1;
            end
            else begin
                start_flag <= 1'b0;
            end
        end
    end
    
    always_ff @(posedge clk or negedge rstn) begin  // forming finish flag
        if (!rstn) begin
            finish_flag <= 1'b0;
        end
        else begin
            if ((state == s_wait) & (op_cnt == 3)) begin
                finish_flag <= 1'b1;
            end
        end
    end
                    
    
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            state <= s_idle;
            miim_wren <= 1'b0;
            miim_rden <= 1'b0;
            miim_phyad <= 5'b0;
            miim_regad <= 5'b0;
            miim_wrdata <= 16'b0;
        end
        else begin
            miim_wren <= 1'b0;
            miim_rden <= 1'b0;
            case(state)

            s_idle:begin
                if (start_flag & !finish_flag) begin
                    state <= s_prep;
                end
                miim_phyad <= 5'b0;
                miim_regad <= 5'b0;
                miim_wrdata <= 16'b0;
            end

            s_prep:        // check rw_reg to get next operation; 1 - write, 0 - read
                if (rw_reg) begin
                    state <= s_writeConf;
                end
                else begin
                    state <= s_readReg;
                end

            s_writeConf:begin
                miim_wren <= 1'b1;
                miim_phyad <= phy_address_reg;
                miim_regad <= reg_address_reg;
                miim_wrdata <= wrdata_reg;
                state <= s_wait;
            end

            s_readReg:begin
                miim_rden <= 1'b1;
                miim_phyad <= phy_address_reg;
                miim_regad <= reg_address_reg;
                miim_wrdata <= wrdata_reg;
                state <= s_wait;
            end

            s_wait:begin                                          // wait end of operations
                if (!busy & (!miim_wren & !miim_rden)) begin
                    state <= s_idle;
                end
            end

            default:
                state <= s_idle;
            endcase
        end
    end
    
    always_ff @(posedge clk or negedge rstn) begin  //increment operation counter
        if (!rstn) begin
            op_cnt <= 8'd0;
        end
        else begin
            if (miim_wren | miim_rden) begin
                op_cnt <= op_cnt + 1'b1;
            end
        end
    end
    
endmodule