module tb_buff;

reg clk;
reg rst_n;
reg read;
reg write;
reg [7:0] data_in;


wire [7:0] data_out;
wire  full;
wire  empty;

integer i;

fifo_buff dut (
.clk(clk), .rst_n(rst_n), .read(read), .write(write), .data_in(data_in), .data_out(data_out), .full(full), .empty(empty)
);

initial begin
    rst_n = 0;
    write = 0;
    read = 0;
    data_in = 0;
    clk = 0;
forever begin
            #20;
            clk = ~clk;
        end
end

initial begin

#20
rst_n <= 1;
data_in <= 8'b1;
#20
for (i=0; i < 64; i=i+1) begin
    #20
    data_in <= 8'b1 + i;
    write <= 1;
end

for (i=0; i < 65; i=i+1) begin
    #20
    read <= 1;
end

$stop;
end

endmodule