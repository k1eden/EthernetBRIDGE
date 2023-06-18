/* 
 THIS MODULE IS RESPONSIBLE FOR FORMING LAST_BYTE SIGNAL, TX_VALID FLAG AND SENDING DATA TO THE MAC
*/
module tx_control(clk, tx_data, tx_data_valid, rst, last_byte, tx_data_o, frm_len, valid_flag, tx_mac_ready, nextByte, empty_buff, rx_frame, nextLen, empty_len_buff);

input clk;
input [7:0] tx_data;
input tx_data_valid;
input rst;
input [15:0] frm_len;
input tx_mac_ready;
input empty_buff;
input rx_frame;
input empty_len_buff;

logic [15:0] pointer;
logic first_iter;
logic finish_flag;
logic proc_flag;


output reg nextByte;
output reg valid_flag;
output reg last_byte;
output reg [7:0] tx_data_o;
output reg nextLen;

typedef enum logic [6:0] {
    s_wait_frame = 7'b0000001,
    s_prepare = 7'b0000010,
    s_prepare2 = 7'b0000100,
    s_send_data = 7'b0001000,
    s_finish_send = 7'b0010000,
    s_finish_send2 = 7'b0100000,
    s_finish_send3 = 7'b1000000
} tx_state;

tx_state state = s_wait_frame;


initial begin
tx_data_o <= 8'h0;
last_byte <= 1'b0;
pointer <= 16'd0;
valid_flag <= 1'b0;
nextByte <= 1'b0;
first_iter <= 1'b1;
finish_flag <= 1'b0;
nextLen <= 1'b1;
proc_flag <= 1'b0;
//state <= wait_frame;
end



always @(posedge clk or negedge rst)
begin
if(!rst)
	begin
        pointer <= 16'd0;
		last_byte <= 1'b0;
        state <= s_wait_frame;
        finish_flag <= 1'b0;
        nextByte <= 1'b0;
	end
else begin
 
 case (state)

    (s_finish_send): begin 
                last_byte <= 1;
                tx_data_o <= tx_data;
                nextByte <= 0;
                state <= s_finish_send2;
            end
  
    (s_finish_send2): begin if (frm_len > 16'd59) begin
                    last_byte <= 0;
                    valid_flag <= 1'b1;
                    nextByte <= 1'b0;
                    state <= s_finish_send3;
               end
               end

    (s_finish_send3): begin if (frm_len > 16'd59) begin
                      pointer <= 16'h0;             
                      tx_data_o <= 16'h0; 
                      last_byte <= 0;
                      valid_flag <= 1'b0;
                      first_iter <= 1'b0;
                      finish_flag <= 1'b1;
                      state <= s_wait_frame;
                        end
                     end

    s_send_data: begin 
                    valid_flag <= 1'b1;
         
                    if (tx_mac_ready) begin 
                        tx_data_o <= tx_data;
                        nextByte <= 1'b1;
                        pointer <= pointer + 1'h1;
                        last_byte <= 1'b0;
                        valid_flag <= 1'b1;
                        if (pointer == frm_len - 16'h1) begin
                            state <= s_finish_send;
                            tx_data_o <= tx_data;
                            end
                    end else nextByte <= 1'b0;
                end

    s_wait_frame: begin if (!empty_buff && frm_len > 0 && !finish_flag) begin
        if (first_iter) begin
        nextByte <= 1'b1;
       //tx_data_o <= tx_data;
     //  pointer <= pointer + 1'h1;
        state <= s_prepare;
        end else begin
       // pointer <= pointer + 1'h1;
        state <= s_prepare;
        end
        end
    end

    s_prepare: begin 
       if (first_iter) begin
        nextLen <= 1'b1; 
        state <= s_prepare2;
        end else begin
         nextLen <= 1'b1;
         nextByte <= 1'b1;
         state <= s_prepare2;
        end
       end

   s_prepare2: begin
        tx_data_o <= tx_data;
        pointer <= pointer + 1'h1;
        nextByte <= 1'b0;
        nextLen <= 1'b0;
        state <= s_send_data;
       end

    default: state <= s_wait_frame;

endcase
   
 if (empty_buff) first_iter <= 1'h1;

 if (!valid_flag && !empty_len_buff) finish_flag <= 1'b0;

end


end
endmodule
