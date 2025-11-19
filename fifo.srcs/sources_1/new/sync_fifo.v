`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2025 20:07:29
// Design Name: 
// Module Name: sync_fifo
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


module sync_fifo #
(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = 4
)
(
    input  wire                clk,
    input  wire                rst,
    input  wire                wr_en,
    input  wire                rd_en,
    input  wire [DATA_WIDTH-1:0] din,
    output reg  [DATA_WIDTH-1:0] dout,
    output wire                full,
    output wire                empty
);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [ADDR_WIDTH:0] w_ptr;
    reg [ADDR_WIDTH:0] r_ptr;

    // full & empty logic
    assign full  = (w_ptr == (r_ptr ^ (1 << ADDR_WIDTH)));
    assign empty = (w_ptr == r_ptr);

    // write
    always @(posedge clk) begin
        if (rst) begin
            w_ptr <= 0;
        end else if (wr_en && !full) begin
            mem[w_ptr[ADDR_WIDTH-1:0]] <= din;
            w_ptr <= w_ptr + 1;
        end
    end

    // read
    always @(posedge clk) begin
        if (rst) begin
            r_ptr <= 0;
            dout  <= 0;
        end else if (rd_en && !empty) begin
            dout <= mem[r_ptr[ADDR_WIDTH-1:0]];
            r_ptr <= r_ptr + 1;
        end
    end
endmodule

