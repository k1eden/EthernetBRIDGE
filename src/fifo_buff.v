/* module fifo_buff (
	input clk,
	input rst_n,
	input read,
	input write,
	input [7:0] data_in,
    input is_another_empty,

	output reg [7:0] data_out,
	output reg  full,
	output reg  empty);

reg [5:0] rpointer;
reg [5:0] wpointer;
reg [7:0] memory [63:0];
// reg read_on;

// initial read_on = read;


always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		data_out <= 8'h00;
		full <= 0;
		empty <= 0;
		rpointer <= 6'b000000;
		wpointer <= 6'b000000;	
	end
	else 
    begin
    if (read &&(rpointer == wpointer - 1 || rpointer == 6'b111111 && 6'b000000 == wpointer)) 
            empty <= 1;
   
    if(write &&(wpointer == rpointer - 1 || wpointer == 6'b111111 && 6'b000000 == rpointer))
            full <= 1;
  
    if(write && !full)
	begin
		memory[wpointer] <= data_in;
		wpointer <= wpointer + 1'b1;
	end
	else if(read && !empty)
	begin
		data_out <= memory[rpointer];
		rpointer <= rpointer + 1'b1;
	end
	else
	begin
		data_out <= data_out;
		wpointer <= wpointer;
		rpointer <= rpointer;
        empty <= 0;
        full <= 0;
        end
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
//endmodule 

module fifo_buff(
input rx_mac_last,
input clk,
input rst_n,
input write,
input read,
input [7:0] data_in,
output reg [7:0] data_out,
output reg empty,
output reg full,
//output reg [10:0] frame_len,
output reg tx_valid_flag
);

// Параметры FIFO
parameter ADDR_WIDTH = 8;
parameter DEPTH = 2**ADDR_WIDTH;

// Сигналы для RAM
reg [7:0] ram [0:DEPTH-1];
reg [ADDR_WIDTH-1:0] wr_ptr = 0;
reg [ADDR_WIDTH-1:0] rd_ptr = 0;

// Сигналы для FIFO
reg [ADDR_WIDTH-1:0] count = 0;
reg [10:0] frame_len_reg = 11'd0;

//initial frame_len <= 11'h0;

// Логика записи в FIFO
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
// Логика чтения из FIFO
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

/*
// Логика чтения из FIFO
always @(posedge clk, posedge rst)
begin
if (rst)
rd_ptr <= 0;
else if (read && !empty)
begin
data_out <= ram[rd_ptr];
rd_ptr <= rd_ptr + 1;
count <= count - 1;
end
end
*/
// Логика проверки пустоты и заполненности FIFO
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
end

endmodule
