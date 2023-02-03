module fifo_buff (
	input clk,
	input rst_n,
	input read,
	input write,
	input [7:0] data_in,
    input is_another_empty,

	output reg [7:0] data_out,
	output reg  full,
	output reg  empty);

reg [3:0] rpointer;
reg [3:0] wpointer;
reg [7:0] memory [15:0];
// reg read_on;

// initial read_on = read;


always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		data_out <= 8'h00;
		full <= 0;
		empty <= 0;
		rpointer <= 4'b0000;
		wpointer <= 4'b0000;	
	end
	else if (read&&(rpointer == wpointer - 1 || rpointer == 4'b1111 && 4'b0000 == wpointer)) 
            empty<=1;
   
    else if(write&&(wpointer == rpointer - 1 || wpointer == 4'b1111 && 4'b0000 == rpointer))
            full<=1;

    else if(write && !full)
	begin
		memory[wpointer] <= data_in;
		wpointer <= wpointer+1'b1;
	end
	else if(read && !empty)
	begin
		data_out <= memory[rpointer];
		rpointer <= rpointer+1'b1;
	end
	else
	begin
		data_out<=data_out;
		wpointer<=wpointer;
		rpointer<=rpointer;
        empty <= 0;
        full <= 0;
	end
end

/*always@(posedge clk)
begin
	if(read && (rpointer == wpointer - 1 || rpointer == 4'b1111 && 4'b0000 == wpointer))
		empty <= 1;
	else 
		empty <= 0;
end

/*always@(posedge clk)
begin
	if(write && (wpointer == rpointer - 1 || wpointer == 4'b1111 && 4'b0000 == rpointer))
		full <= 1;
	else
		full <=0;
end

/* always@ (posedge clk)
begin
if (!is_another_empty && read == 1'b0) read <= 1'b1; 
    else 
        read <= 1'b0; 
end
*/
endmodule
