`timescale 1ns/1ps
module mac_mii_tx_model(
 //   output mac_mii_tx_clk_o,
    output reg mac_mii_tx_dv_o,
    output reg [7:0] mac_mii_txd_o
  //  input speedis1000,
  //  input speedis10
    );

/*reg clk;
    
    initial begin
        clk = 0;
        forever begin
            if (speedis1000) begin //1000M clk
                #4 clk = !clk;
            end
            else if (!speedis10) begin //100M clk
                #20 clk = !clk;
            end
            else begin//10M clk
                #200 clk = !clk; 
            end
        end
    end 

 assign #4 mac_mii_tx_clk_o = clk;
*/
initial begin
        mac_mii_tx_dv_o = 1'b0;
        mac_mii_txd_o = 8'b0;
    end

task start_tx_test;
input tx_mac_ready;

integer i;
begin
mac_mii_tx_dv_o <= 1'b1;
mac_mii_txd_o <= 8'h11;

for (i = 0; i < 11; i = i+1) begin
@(posedge tx_mac_ready);
mac_mii_txd_o <= 8'ha;
@(negedge tx_mac_ready);
mac_mii_txd_o <= 8'ha;
end
end
endtask

endmodule