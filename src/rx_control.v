module rx_control (tx_clk, tx_pause_source_addr_r, is_fifo_full, tx_pause_req, tx_pause_val);

input tx_clk;
input is_fifo_full;

output reg [47:0] tx_pause_source_addr_r;
output reg tx_pause_req;
output reg [15:0] tx_pause_val;

localparam [47:0]  tx_pause_source_addr = 48'h0180C2000001;


always @(posedge tx_clk) 
begin
    if (is_fifo_full) begin
        tx_pause_req <= 1'b1;
        tx_pause_val <= 16'h5a0f;
        tx_pause_source_addr_r <= tx_pause_source_addr;
    end
    else begin
        tx_pause_req <= 1'h0;  
        tx_pause_val <= 16'h0;
        tx_pause_source_addr_r = 48'h0;
        end
end

endmodule
