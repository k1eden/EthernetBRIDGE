module sync_fifo(
	input clk,
	input rst_n,
	input rd,
	input wr,
	input [7:0] data_in,
	output reg [7:0] data_out,
	output reg  full,
	output reg  empty);
reg [3:0] rp;
reg [3:0] wp;
reg [7:0] memory [15:0];
// Генерируем адрес указателя чтения и указателя записи, записываем данные в FIFO в соответствии с указателем записи и считываем данные из FIFO в соответствии с указателем чтения
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		data_out<=8'h00;
		full<=0;
		empty<=0;
		rp<=4'b0000;
		wp<=4'b0000;	
	end
	else if(wr&&!full)
	begin
		memory[wp]<=data_in;
		wp<=wp+1'b1;
	end
	else if(rd&&!empty)
	begin
		data_out<=memory[rp];
		rp<=rp+1'b1;
	end
	else
	begin
		data_out<=data_out;
		wp<=wp;
		rp<=rp;
	end
end
 // Генерируем пустой сигнал чтения
always@(posedge clk)
begin
	if(rd&&(rp==wp-1||rp==4'b1111&&4'b0000==wp))
		empty<=1;
	else 
		empty<=0;
end
 // Генерируем полный сигнал
always@(posedge clk)
begin
	if(wr&&(wp==rp-1||wp==4'b1111&&4'b0000==rp))
		full<=1;
	else
		full<=0;
end
endmodule