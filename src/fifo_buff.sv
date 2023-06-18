/* 
 THIS MODULE IS RESPONSIBLE FOR COLLECTING FRAMES AND SENDING THEM TO THE TX_CONTROL MODULE
*/
module fifo_buff #(parameter ADDR_WIDTH = 8, parameter DEPTH = 256)(
input rx_mac_last,
input clk,
input rst_n,
input write,
input read,
input [ADDR_WIDTH - 1:0] data_in,
output reg [ADDR_WIDTH - 1:0] data_out,
output reg empty,
output reg full,
output reg almost_full,
//output reg [10:0] frame_len,
output reg tx_valid_flag
);
 
// RAM Signals
reg [ADDR_WIDTH - 1:0] ram [0:DEPTH-1];
reg [ADDR_WIDTH-1:0] wr_ptr = 0;
reg [ADDR_WIDTH-1:0] rd_ptr = 0;

// FIFO Signals
reg [ADDR_WIDTH-1:0] count = 0;
reg [10:0] frame_len_reg = 11'd0;

initial begin 
    data_out = 8'h0;
    full = 1'b0;
    empty = 1'b1;
end
// Write op
always @(posedge clk, negedge rst_n)
begin
if (!rst_n) begin
    wr_ptr <= 0;
    rd_ptr <= 0;
end
else 
    begin
        if (write && !full)
        begin
            ram[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
            count <= count + 1;
            frame_len_reg <= frame_len_reg + 1'd1;
        end
// Read op
        if (read && !empty) begin
            data_out <= ram[rd_ptr];
            rd_ptr <= rd_ptr + 1;
            count <= count - 1;
        end

        if (rx_mac_last) begin 
         // frame_len <= frame_len_reg + 1'd1; // + 1 Из-за 1 такта задержки
            frame_len_reg <= 1'b0;
        end 
 
        if (frame_len_reg != 1'b0 || rd_ptr != wr_ptr)
            tx_valid_flag <= 1'b1; else tx_valid_flag <= 1'b0; 
    end
end

// full/empty check
always @(count)
begin
    if (count == 0)
        empty <= 1;
    else
        empty <= 0;

    if (count == DEPTH)
        full <= 1;
    else
        full <= 0;

    if (count == DEPTH - 1'h1)
        almost_full <= 1;
    else
        almost_full <= 0;
end

endmodule
