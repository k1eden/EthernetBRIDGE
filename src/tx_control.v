module tx_control(clk, tx_data, tx_data_valid, rst, last_byte);

input clk;
input [7:0] tx_data;
input tx_data_valid;
input rst;

reg [7:0] memory [63:0];
reg [5:0] pointer;


output reg last_byte;

always@(posedge clk or negedge rst)
begin
if(!rst)
	begin
        pointer <= 0;
		last_byte <= 0;
	end
else
 case (pointer)
    6'b111111: begin 
                    last_byte <= 1;
                    pointer <= 6'b000000;
               end

    default:   if (tx_data_valid) begin
                    last_byte <= 0;
                    memory[pointer] <= tx_data;
                    pointer <= pointer + 1'b1;
                    end
endcase
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
