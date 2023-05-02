`timescale 1ns/1ps
module phy_mii_rx_model(
    output phy_mii_rx_clk_o,
    output reg phy_mii_rx_dv_o,
    output reg [3:0] phy_mii_rxd_o,
    input speedis1000,
    input speedis10,
    input start
    );
    
    reg clk;
    
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
    
    // assign #2 phy_mii_rx_clk_o = clk;
    assign #4 phy_mii_rx_clk_o = clk;
    
    reg [9:0] mem [0:1517];//[7:0]:data;[8]:er;[9]:en
    
    initial begin
        phy_mii_rx_dv_o = 1'b0;
        phy_mii_rxd_o = 4'b0;
    end
    
    task phy_mii_rx_frame_en;
        input [47:0] dest_mac;
        input [47:0] sour_mac;
        input vlan_en;
        input [15:0] vlan;
        input mac_ctrl_en;
        input [7:0] data_start;
        input [15:0] frame_lgt;//include crc and vlan
        input crc_error;
        input rx_er_en;
        input [15:0] rx_er_site; 
        input flow_ctrl_en;
        input [15:0] pause_val;
        begin
            set_phy_rx_frame_task(dest_mac,sour_mac,vlan_en,vlan,mac_ctrl_en,data_start,frame_lgt,crc_error,rx_er_en,rx_er_site,flow_ctrl_en,pause_val);
            phy_rgmii_rx_frame_task(frame_lgt);
        end
    endtask
    
    task phy_rgmii_rx_frame_task;
        input [15:0] frame_lgt;//include CRC
        integer i;
        begin
            if (speedis1000) begin//1000M
                phy_mii_rx_dv_o = 0;
                phy_mii_rxd_o = 0;
                for (i=0;i<7;i=i+1) begin
                    @(posedge clk);
                    phy_mii_rx_dv_o <= 1'b1;
                    phy_mii_rxd_o <= 4'h5;
                    @(negedge clk);
                    phy_mii_rx_dv_o <= 1'b1;
                    phy_mii_rxd_o <= 4'h5;
                end
                @(posedge clk);
                phy_mii_rx_dv_o <= 1'b1;
                phy_mii_rxd_o <= 4'h5;
                @(negedge clk);
                phy_mii_rx_dv_o <= 1'b1;
                phy_mii_rxd_o <= 4'hd;
                for(i=0;i<frame_lgt;i=i+1) begin
                    @(posedge clk);
                    phy_mii_rx_dv_o <= mem[i][9];
                    phy_mii_rxd_o <= mem[i][3:0];
                    @(negedge clk);
                    phy_mii_rx_dv_o <= mem[i][9] ^ mem[i][8];
                    phy_mii_rxd_o <= mem[i][7:4];
                end
                @(posedge clk);
                phy_mii_rx_dv_o = 0;
                phy_mii_rxd_o = 0;
            end
            else begin
                phy_mii_rx_dv_o = 0;
                phy_mii_rxd_o = 0;
                for (i=0;i<14;i=i+1) begin
                    @(posedge clk);
                    phy_mii_rx_dv_o <= 1'b1;
                    phy_mii_rxd_o <= 4'h5;
                    @(negedge clk);
                    phy_mii_rx_dv_o <= 1'b1;
                    phy_mii_rxd_o <= 4'h5;
                end
                @(posedge clk);
                phy_mii_rx_dv_o <= 1'b1;
                phy_mii_rxd_o <= 4'h5;
                @(negedge clk);
                phy_mii_rx_dv_o <= 1'b1;
                phy_mii_rxd_o <= 4'h5;
                @(posedge clk);
                phy_mii_rx_dv_o <= 1'b1;
                phy_mii_rxd_o <= 4'hd;
                @(negedge clk);
                phy_mii_rx_dv_o <= 1'b1;
                phy_mii_rxd_o <= 4'hd;
                
                for(i=0;i<frame_lgt;i=i+1) begin
                    if (i<frame_lgt-1) begin
                        @(posedge clk);
                        phy_mii_rx_dv_o <= mem[i][9];
                        phy_mii_rxd_o <= mem[i][3:0];
                        @(negedge clk);
                        phy_mii_rx_dv_o <= mem[i][9] ^ mem[i][8];
                        phy_mii_rxd_o <= mem[i][3:0];
                        @(posedge clk);
                        phy_mii_rx_dv_o <= mem[i][9];
                        phy_mii_rxd_o <= mem[i][7:4];
                        @(negedge clk);
                        phy_mii_rx_dv_o <= mem[i][9] ^ mem[i][8];
                        phy_mii_rxd_o <= mem[i][7:4];
                    end
                    else if (i<frame_lgt) begin
                        @(posedge clk);
                        phy_mii_rx_dv_o <= mem[i][9];
                        phy_mii_rxd_o <= mem[i][3:0];
                        @(negedge clk);
                        phy_mii_rx_dv_o <= mem[i][9] ^ mem[i][8];
                        phy_mii_rxd_o <= mem[i][3:0];
                        @(posedge clk);
                        phy_mii_rx_dv_o <= mem[i][9];
                        phy_mii_rxd_o <= mem[i][7:4];
                        @(negedge clk);
                        phy_mii_rx_dv_o <= mem[i][9] ^ mem[i][8];
                        phy_mii_rxd_o <= mem[i][7:4];
                    end
                end
                @(posedge clk);
                phy_mii_rx_dv_o = 0;
                phy_mii_rxd_o = 0;
            end
        end
    endtask
    
    task phy_rgmii_rx_er_only_for_col_test_task;
        input [15:0] rx_er_lgt;//include CRC
        integer i;
        begin
            if (speedis1000) begin//1000M
                phy_mii_rx_dv_o = 0;
                phy_mii_rxd_o = 0;
                for (i=0;i<rx_er_lgt;i=i+1) begin
                    @(posedge clk);
                    phy_mii_rx_dv_o <= 1'b0;
                    phy_mii_rxd_o <= 4'h0;
                    @(negedge clk);
                    phy_mii_rx_dv_o <= 1'b1;
                    phy_mii_rxd_o <= 4'h0;
                end
                @(posedge clk);
                phy_mii_rx_dv_o = 0;
                phy_mii_rxd_o = 0;
            end
            else begin
                phy_mii_rx_dv_o = 0;
                phy_mii_rxd_o = 0;
                for (i=0;i<rx_er_lgt;i=i+1) begin
                    @(posedge clk);
                    phy_mii_rx_dv_o <= 1'b0;
                    phy_mii_rxd_o <= 4'h0;
                    @(negedge clk);
                    phy_mii_rx_dv_o <= 1'b1;
                    phy_mii_rxd_o <= 4'h0;
                    @(posedge clk);
                    phy_mii_rx_dv_o <= 1'b0;
                    phy_mii_rxd_o <= 4'h0;
                    @(negedge clk);
                    phy_mii_rx_dv_o <= 1'b1;
                    phy_mii_rxd_o <= 4'h0;
                end
                @(posedge clk);
                phy_mii_rx_dv_o = 0;
                phy_mii_rxd_o = 0;
            end
        end
    endtask
   
    task phy_rgmii_rx_frame_inband_status_task;
        begin
            @(posedge clk);
            phy_mii_rx_dv_o <= 0;
            phy_mii_rxd_o <= 0;
            
        end
    endtask
    
    
    
    task set_phy_rx_frame_task;
        input [47:0] dest_mac;
        input [47:0] sour_mac;
        input vlan_en;
        input [15:0] vlan;
        input mac_ctrl_en;
        input [7:0] data_start;
        input [15:0] frame_lgt;//include crc and vlan
        input crc_error;
        input rx_er_en;
        input [15:0] rx_er_site; 
        input flow_ctrl_en;
        input [15:0] pause_val;
        
        
        integer i;
        reg [7:0] data;
        reg [31:0] crc_tmp;
        reg [31:0] crc_result;
        reg [47:0] dest_mac_reg;
        begin
            data = data_start;
            dest_mac_reg = dest_mac;
            if (flow_ctrl_en) begin
                for(i=0;i<frame_lgt-4;i=i+1) begin //not include crc
                    if (!vlan_en) begin
                        //dest_mac
                        if (i == 0) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h01};
                        end
                        else if (i == 1) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h80};
                        end
                        else if (i == 2) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'hc2};
                        end
                        else if (i == 3) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h00};
                        end
                        else if (i == 4) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h00};
                        end
                        else if (i == 5) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h01};
                        end
                        //source mac
                        else if (i < 12) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),sour_mac[8*(11-i)+:8]};
                        end
                        //type and op
                        else if (i == 12) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h88};
                        end
                        else if (i == 13) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h08};
                        end
                        else if (i == 14) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h00};
                        end
                        else if (i == 15) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h01};
                        end
                        else if (i == 16) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),pause_val[15:8]};
                        end
                        else if (i == 17) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),pause_val[7:0]};
                        end
                        
                        else begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h00};  
                        end    
                    end
                    else begin
                        //dest_mac
                        if (i == 0) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h01};
                        end
                        else if (i == 1) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h80};
                        end
                        else if (i == 2) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'hc2};
                        end
                        else if (i == 3) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h00};
                        end
                        else if (i == 4) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h00};
                        end
                        else if (i == 5) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h01};
                        end
                        //source mac
                        else if (i < 12) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),sour_mac[8*(11-i)+:8]};
                        end
                        //vlan
                        else if (i == 12) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h81};
                        end
                        else if (i == 13) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h00};
                        end
                        else if (i == 14) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),vlan[15:8]};
                        end
                        else if (i == 15) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),vlan[7:0]};
                        end
                        //type and op
                        else if (i == 16) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h88};
                        end
                        else if (i == 17) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h08};
                        end
                        else if (i == 18) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h00};
                        end
                        else if (i == 19) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h01};
                        end
                        else if (i == 20) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),pause_val[15:8]};
                        end
                        else if (i == 21) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),pause_val[7:0]};
                        end
                        else begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h00};  
                        end 
                    end
                    if (i == 0) begin
                        crc_tmp = NextCRC(mem[i],{32{1'b1}});
                    end
                    else begin
                        crc_tmp = NextCRC(mem[i],crc_tmp);
                    end
                end
            end
            else begin
                for(i=0;i<frame_lgt-4;i=i+1) begin //not include crc
                    if (!vlan_en & !mac_ctrl_en) begin
                        //dest_mac
                        if (i < 6) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),dest_mac_reg[8*(5-i)+:8]};
                        end
                        //source mac
                        else if (i < 12) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),sour_mac[8*(11-i)+:8]};
                        end
                        else begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),data};
                            data = data + 1;
                        end
                    end
                    else if (vlan_en & !mac_ctrl_en) begin
                        //dest_mac
                        if (i < 6) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),dest_mac_reg[8*(5-i)+:8]};
                        end
                        //source mac
                        else if (i < 12) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),sour_mac[8*(11-i)+:8]};
                        end
                        //vlan
                        else if (i == 12) 
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h81};
                        else if (i == 13) 
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h00};
                        else if (i == 14) 
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),vlan[15:8]};
                        else if (i == 15) 
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),vlan[7:0]};
                        else begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),data};
                            data = data + 1;
                        end
                    end
                    else if (!vlan_en & mac_ctrl_en) begin
                        //dest_mac
                        if (i < 6) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),dest_mac_reg[8*(5-i)+:8]};
                        end
                        //source mac
                        else if (i < 12) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),sour_mac[8*(11-i)+:8]};
                        end
                        //0x8808
                        else if (i == 12) 
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h88};
                        else if (i == 13) 
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h08};
                        else begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),data};
                            data = data + 1;
                        end
                    end
                    else begin
                        //dest_mac
                        if (i < 6) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),dest_mac_reg[8*(5-i)+:8]};
                        end
                        //source mac
                        else if (i < 12) begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),sour_mac[8*(11-i)+:8]};
                        end
                        //vlan
                        else if (i == 12) 
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h81};
                        else if (i == 13) 
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h00};
                        else if (i == 14) 
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),vlan[15:8]};
                        else if (i == 15) 
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),vlan[7:0]};
                        else if (i == 16)
                             mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h88};
                        else if (i == 17)
                             mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),8'h08};     
                        else begin
                            mem[i] = {1'b1,((rx_er_site-1 == i) & rx_er_en),data};
                            data = data + 1;
                        end
                    end
                    if (i == 0) begin
                        crc_tmp = NextCRC(mem[i],{32{1'b1}});
                    end
                    else begin
                        crc_tmp = NextCRC(mem[i],crc_tmp);
                    end
                end
            end
            crc_result[7:0] = (!crc_error) ? ~{crc_tmp[24],crc_tmp[25],crc_tmp[26],crc_tmp[27],crc_tmp[28],crc_tmp[29],crc_tmp[30],crc_tmp[31]} : {crc_tmp[24],crc_tmp[25],crc_tmp[26],crc_tmp[27],crc_tmp[28],crc_tmp[29],crc_tmp[30],crc_tmp[31]};
            crc_result[15:8] = ~{crc_tmp[16],crc_tmp[17],crc_tmp[18],crc_tmp[19],crc_tmp[20],crc_tmp[21],crc_tmp[22],crc_tmp[23]};
            crc_result[23:16] = ~{crc_tmp[8],crc_tmp[9],crc_tmp[10],crc_tmp[11],crc_tmp[12],crc_tmp[13],crc_tmp[14],crc_tmp[15]};
            crc_result[31:24] = ~{crc_tmp[0],crc_tmp[1],crc_tmp[2],crc_tmp[3],crc_tmp[4],crc_tmp[5],crc_tmp[6],crc_tmp[7]};
            mem[frame_lgt - 4] = {1'b1,((rx_er_site-1 == frame_lgt - 4) & rx_er_en),crc_result[7:0]};
            mem[frame_lgt - 3] = {1'b1,((rx_er_site-1 == frame_lgt - 3) & rx_er_en),crc_result[15:8]};
            mem[frame_lgt - 2] = {1'b1,((rx_er_site-1 == frame_lgt - 2) & rx_er_en),crc_result[23:16]};
            mem[frame_lgt - 1] = {1'b1,((rx_er_site-1 == frame_lgt - 1) & rx_er_en),crc_result[31:24]};
        end
    endtask

    function[31:0]  NextCRC;
        input[7:0]      D;
        input[31:0]     C;
        reg[31:0]       NewCRC;
        begin
        NewCRC[0]=C[24]^C[30]^D[1]^D[7];
        NewCRC[1]=C[25]^C[31]^D[0]^D[6]^C[24]^C[30]^D[1]^D[7];
        NewCRC[2]=C[26]^D[5]^C[25]^C[31]^D[0]^D[6]^C[24]^C[30]^D[1]^D[7];
        NewCRC[3]=C[27]^D[4]^C[26]^D[5]^C[25]^C[31]^D[0]^D[6];
        NewCRC[4]=C[28]^D[3]^C[27]^D[4]^C[26]^D[5]^C[24]^C[30]^D[1]^D[7];
        NewCRC[5]=C[29]^D[2]^C[28]^D[3]^C[27]^D[4]^C[25]^C[31]^D[0]^D[6]^C[24]^C[30]^D[1]^D[7];
        NewCRC[6]=C[30]^D[1]^C[29]^D[2]^C[28]^D[3]^C[26]^D[5]^C[25]^C[31]^D[0]^D[6];
        NewCRC[7]=C[31]^D[0]^C[29]^D[2]^C[27]^D[4]^C[26]^D[5]^C[24]^D[7];
        NewCRC[8]=C[0]^C[28]^D[3]^C[27]^D[4]^C[25]^D[6]^C[24]^D[7];
        NewCRC[9]=C[1]^C[29]^D[2]^C[28]^D[3]^C[26]^D[5]^C[25]^D[6];
        NewCRC[10]=C[2]^C[29]^D[2]^C[27]^D[4]^C[26]^D[5]^C[24]^D[7];
        NewCRC[11]=C[3]^C[28]^D[3]^C[27]^D[4]^C[25]^D[6]^C[24]^D[7];
        NewCRC[12]=C[4]^C[29]^D[2]^C[28]^D[3]^C[26]^D[5]^C[25]^D[6]^C[24]^C[30]^D[1]^D[7];
        NewCRC[13]=C[5]^C[30]^D[1]^C[29]^D[2]^C[27]^D[4]^C[26]^D[5]^C[25]^C[31]^D[0]^D[6];
        NewCRC[14]=C[6]^C[31]^D[0]^C[30]^D[1]^C[28]^D[3]^C[27]^D[4]^C[26]^D[5];
        NewCRC[15]=C[7]^C[31]^D[0]^C[29]^D[2]^C[28]^D[3]^C[27]^D[4];
        NewCRC[16]=C[8]^C[29]^D[2]^C[28]^D[3]^C[24]^D[7];
        NewCRC[17]=C[9]^C[30]^D[1]^C[29]^D[2]^C[25]^D[6];
        NewCRC[18]=C[10]^C[31]^D[0]^C[30]^D[1]^C[26]^D[5];
        NewCRC[19]=C[11]^C[31]^D[0]^C[27]^D[4];
        NewCRC[20]=C[12]^C[28]^D[3];
        NewCRC[21]=C[13]^C[29]^D[2];
        NewCRC[22]=C[14]^C[24]^D[7];
        NewCRC[23]=C[15]^C[25]^D[6]^C[24]^C[30]^D[1]^D[7];
        NewCRC[24]=C[16]^C[26]^D[5]^C[25]^C[31]^D[0]^D[6];
        NewCRC[25]=C[17]^C[27]^D[4]^C[26]^D[5];
        NewCRC[26]=C[18]^C[28]^D[3]^C[27]^D[4]^C[24]^C[30]^D[1]^D[7];
        NewCRC[27]=C[19]^C[29]^D[2]^C[28]^D[3]^C[25]^C[31]^D[0]^D[6];
        NewCRC[28]=C[20]^C[30]^D[1]^C[29]^D[2]^C[26]^D[5];
        NewCRC[29]=C[21]^C[31]^D[0]^C[30]^D[1]^C[27]^D[4];
        NewCRC[30]=C[22]^C[31]^D[0]^C[28]^D[3];
        NewCRC[31]=C[23]^C[29]^D[2];
        NextCRC=NewCRC;
        end
    endfunction

    always @(posedge start)
    phy_mii_rx_frame_en(48'h12d146111011,48'h59abcdef1122,1'b0,16'hab12,1'b1,8'h19,16'd100,1'b0,1'b0,16'd0,1'b0,16'h0);
endmodule

