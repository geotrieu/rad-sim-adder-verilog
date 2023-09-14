`define DATAW 128
`timescale 1ns/10ps

module fifo_tb;
    parameter DATAW = 8;
    
    reg clk, rst;
    reg w, r;
    reg [DATAW-1:0] data_in;
    wire [DATAW-1:0] data_out;
    wire full, empty;
	 
	integer i;

    fifo my_fifo(clk, rst, w, r, data_in, data_out, full, empty);

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
  
    initial begin
        rst <= 1'b1;
        w <= 1'b0;
        r <= 1'b0;
        data_in <= 0;
		@(posedge clk);
        rst <= 0;

        // write sequence
        @(posedge clk);
        w <= 1'b1;
        for (i=1; i <= 8; i = i + 1) begin
			data_in <= i;
            @(posedge clk);
        end

        @(negedge clk);
        w <= 1'b0;
			
        // read and pop sequence
		@(posedge clk);
        r <= 1'b1;
        for (i=1; i <= 8; i = i + 1) begin
            @(posedge clk);
        end

        @(negedge clk);  
		r <= 1'b0;
    end
endmodule