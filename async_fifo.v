module async_fifo #
(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = 4
)
(
    input  wire                   wr_clk,
    input  wire                   rd_clk,
    input  wire                   rst,
    input  wire                   wr_en,
    input  wire                   rd_en,
    input  wire [DATA_WIDTH-1:0]  din,
    output reg  [DATA_WIDTH-1:0]  dout,
    output wire                   full,
    output wire                   empty
);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    reg [ADDR_WIDTH:0] w_bin, r_bin;
    reg [ADDR_WIDTH:0] w_gray, r_gray;

    reg [ADDR_WIDTH:0] w_gray_sync1, w_gray_sync2;
    reg [ADDR_WIDTH:0] r_gray_sync1, r_gray_sync2;

    // gray-code function
    function [ADDR_WIDTH:0] bin2gray(input [ADDR_WIDTH:0] b);
        bin2gray = (b >> 1) ^ b;
    endfunction

    // sync write pointer into read clock domain
    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin
            w_gray_sync1 <= 0;
            w_gray_sync2 <= 0;
        end else begin
            w_gray_sync1 <= w_gray;
            w_gray_sync2 <= w_gray_sync1;
        end
    end

    // sync read pointer into write clock domain
    always @(posedge wr_clk or posedge rst) begin
        if (rst) begin
            r_gray_sync1 <= 0;
            r_gray_sync2 <= 0;
        end else begin
            r_gray_sync1 <= r_gray;
            r_gray_sync2 <= r_gray_sync1;
        end
    end

    assign full  = (bin2gray(w_bin + 1) == {~r_gray_sync2[ADDR_WIDTH:ADDR_WIDTH-1], r_gray_sync2[ADDR_WIDTH-2:0]});
    assign empty = (w_gray_sync2 == r_gray);

    // write domain
    always @(posedge wr_clk or posedge rst) begin
        if (rst) begin
            w_bin  <= 0;
            w_gray <= 0;
        end else if (wr_en && !full) begin
            mem[w_bin[ADDR_WIDTH-1:0]] <= din;
            w_bin  <= w_bin + 1;
            w_gray <= bin2gray(w_bin + 1);
        end
    end

    // read domain
    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin
            r_bin  <= 0;
            r_gray <= 0;
            dout   <= 0;
        end else if (rd_en && !empty) begin
            dout   <= mem[r_bin[ADDR_WIDTH-1:0]];
            r_bin  <= r_bin + 1;
            r_gray <= bin2gray(r_bin + 1);
        end
    end
endmodule
