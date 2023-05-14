/* 
 THIS MODULE RESPONSE FOR FORMING LAST_BYTE SIGNAL, TX_VALID FLAG AND SENDING DATA
*/
module tx_control(clk, tx_data, tx_data_valid, rst, last_byte, tx_data_o, frm_len, valid_flag, tx_mac_ready, nextByte, empty_buff);

input clk;
input [7:0] tx_data;
input tx_data_valid;
input rst;
input [15:0] frm_len;
input tx_mac_ready;
input empty_buff;


reg [7:0] memory [255:0];
reg [15:0] pointer;


output reg nextByte;
output reg valid_flag;
output reg last_byte;
output reg [7:0] tx_data_o;

initial begin
tx_data_o <= 8'h0;
last_byte <= 1'b0;
pointer <= 16'd0;
valid_flag <= 1'b0;
nextByte <= 1'b0;
end

always@(posedge clk or negedge rst)
begin
if(!rst)
	begin
        pointer <= 16'd0;
		last_byte <= 1'b0;
	end
else begin
 //   if (pointer == 16'd0) nextByte <= 1'b1;
 case (pointer)
    (frm_len + 16'h3): begin if (frm_len > 16'd63) begin
                    last_byte <= 1;
                    pointer <= pointer + 1'h1;
                  //  pointer <= 16'h0;
                    valid_flag <= 1'b1;
               end
               end

    (frm_len + 16'h4): begin if (frm_len > 16'd63) begin
                      pointer <= 16'h0;             
                      tx_data_o <= 16'h0; 
                      last_byte <= 0;
                      valid_flag <= 1'b0;
                        end
                     end

    default: begin // if (tx_data_valid) begin
                  //  last_byte <= 1'b0;
                  //  valid_flag <= 1'b1;
                  //  nextByte <= 1'b0;
                   /*memory[pointer]*/ // tx_data_o <= tx_data;
                  //  pointer <= pointer + 1'h1;
                   // wait(tx_mac_ready);
                  //  end
                    valid_flag <= 1'b1;

                    if (tx_mac_ready /*valid_flag*/) begin 
                      //  if (pointer == frm_len + 16'h2) last_byte <= 1;
                        tx_data_o <= tx_data;
                        nextByte <= 1'b1;
                        pointer <= pointer + 1'h1;
                        last_byte <= 1'b0;
                        valid_flag <= 1'b1;
                    end else nextByte <= 1'b0;
                end

    0: begin if (!empty_buff) begin
       nextByte <= 1'b1;
   // tx_data_o <= tx_data;
    pointer <= pointer + 1'h1;
        end
    end

    1: begin
        tx_data_o <= tx_data;
      //  nextByte <= 1'b1;
      //  valid_flag <= 1'b1;
        pointer <= pointer + 1'h1;
       end

   2: begin
        tx_data_o <= tx_data;
      //  nextByte <= 1'b1;
      //  valid_flag <= 1'b1;
        pointer <= pointer + 1'h1;
        nextByte <= 1'b0;
       end

/*    2: begin
        tx_data_o <= tx_data;
    //    nextByte <= 1'b0;
        valid_flag <= 1'b1;
        pointer <= pointer + 1'h1;
       end */
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
