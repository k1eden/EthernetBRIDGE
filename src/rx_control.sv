module rx_control (tx_clk, rstn, rx_dv, tx_pause_source_addr_r, is_fifo_full, tx_pause_req, tx_pause_val);

input tx_clk;
input is_fifo_full;
input rstn;
input rx_dv;

output reg [47:0] tx_pause_source_addr_r;
output reg tx_pause_req;
output reg [15:0] tx_pause_val;

localparam [47:0]  tx_pause_source_addr = 48'h0180C2000001;

typedef enum logic [2:0] {
    s_idle = 3'd0,
    s_send_stopFrame = 3'd1,
    s_wait = 3'd2
} tx_pause_state;

tx_pause_state state = s_idle;


always @(posedge tx_clk, negedge rstn) 
begin
    if (!rstn) begin
        tx_pause_req <= 1'h0;  
        tx_pause_val <= 16'h0;
        tx_pause_source_addr_r <= 48'h0;
        state <= s_idle;
    end else
    case (state)
        
        s_idle: if (is_fifo_full)
            state <= s_send_stopFrame;

        s_send_stopFrame: begin
            tx_pause_req <= 1'b1;
            tx_pause_val <= 16'h5a0f;
            tx_pause_source_addr_r <= tx_pause_source_addr;
            state <= s_wait;
        end

        s_wait: begin
            tx_pause_req <= 1'b0;
            tx_pause_val <= 16'h0;
            tx_pause_source_addr_r <= 48'h0;
            if (rx_dv)
                state <= s_idle;
        end
    endcase
end

endmodule
