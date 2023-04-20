/* 
 THIS MODULE RESPONSE FOR FORMING LAST_BYTE SIGNAL, TX_VALID FLAG AND SENDING DATA
*/
module tx_control(clk, tx_data, tx_data_valid, rst, last_byte, tx_data_o, frm_len, valid_flag, tx_mac_ready);

input clk;
input [7:0] tx_data;
input tx_data_valid;
input rst;
input [15:0] frm_len;
input tx_mac_ready;

reg [7:0] memory [255:0];
reg [15:0] pointer;

output reg valid_flag;
output reg last_byte;
output reg [7:0] tx_data_o;

initial begin
tx_data_o <= 8'hd2;
last_byte <= 1'h0;
pointer <= 16'd0;
valid_flag <= 1'b0;
end

always@(posedge clk or negedge rst)
begin
if(!rst)
	begin
        pointer <= 0;
		last_byte <= 0;
	end
else begin
 case (pointer)
    frm_len: begin if(frm_len > 16'd63) begin
                    last_byte <= 1;
                    pointer <= 16'h0;
                    valid_flag <= 1'b0;
               end
               end

    default: begin  if (tx_data_valid) begin
                    last_byte <= 1'b0;
                    valid_flag <= 1'b1;
                   /*memory[pointer]*/ // tx_data_o <= tx_data;
                   // pointer <= pointer + 1'h1;
                   // wait(tx_mac_ready);
                    end
                    
                    if (tx_mac_ready) tx_data_o <= tx_data;
                    
                end
endcase
end


end
endmodule
/*    if (pointer == 6'b111111)
 begin
        last_byte <= 1;
        pointer <= 6'b000000;
    else 
        last_byte <= 0;
 end 
end */
