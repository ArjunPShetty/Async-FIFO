`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2025 20:09:04
// Design Name: 
// Module Name: async_fifo_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module async_fifo_tb;

    reg wr_clk = 0, rd_clk = 0;
    reg rst   = 1;
    reg wr_en = 0, rd_en = 0;
    reg [7:0] din;
    wire [7:0] dout;
    wire full, empty;

    async_fifo dut(
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    always #5  wr_clk = ~wr_clk;   // 100 MHz
    always #7  rd_clk = ~rd_clk;   // ~71 MHz

    initial begin
        #20 rst = 0;

        repeat(10) begin
            @(posedge wr_clk);
            wr_en = 1;
            din = $random;
        end
        wr_en = 0;

        #100;

        repeat(10) begin
            @(posedge rd_clk);
            rd_en = 1;
        end
        rd_en = 0;

        #200 $finish;
    end
endmodule

