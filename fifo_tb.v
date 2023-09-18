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
 	   w <= 1'b0;
			
	   // read and pop sequence
		@(posedge clk);
	   r <= 1'b1;
	   for (i=1; i <= 3; i = i + 1) begin
			@(posedge clk);
	   end
		r <= 1'b0;
		
		// write and pop sequence
	   @(posedge clk);
	   w <= 1'b1;
		r <= 1'b1;
	   for (i=9; i <= 13; i = i + 1) begin
			data_in <= i;
			@(posedge clk);
	   end
		w <= 1'b0;
		for (i=1; i <= 5; i = i + 1) begin
			@(posedge clk);
      end
		r <= 1'b0;
		
		// test write and read on full case (write should not occur on 9)
		// write sequence
	   @(posedge clk);
	   w <= 1'b1;
	   for (i=1; i <= 8; i = i + 1) begin
			data_in <= i;
			@(posedge clk);
	   end
 	   w <= 1'b0;
		// write and pop sequence
	   @(posedge clk);
	   w <= 1'b1;
		r <= 1'b1;
	   for (i=9; i <= 10; i = i + 1) begin
			data_in <= i;
			@(posedge clk);
	   end
		w <= 1'b0;
		r <= 1'b0;
		// read and pop sequence
		@(posedge clk);
	   r <= 1'b1;
	   for (i=1; i <= 7; i = i + 1) begin
			@(posedge clk);
	   end
		r <= 1'b0;
		
		// test write and read on empty case (pop should not occur on the first read)
		// write sequence
	   @(posedge clk);
	   w <= 1'b1;
	   for (i=1; i <= 1; i = i + 1) begin
			data_in <= i;
			@(posedge clk);
	   end
 	   w <= 1'b0;
		// read and pop sequence
		@(posedge clk);
	   r <= 1'b1;
	   for (i=1; i <= 1; i = i + 1) begin
			@(posedge clk);
	   end
		r <= 1'b0;
		// write and pop sequence
	   @(posedge clk);
	   w <= 1'b1;
		r <= 1'b1;
	   for (i=2; i <= 3; i = i + 1) begin
			data_in <= i;
			@(posedge clk);
	   end
		w <= 1'b0;
		r <= 1'b0;
		// read and pop sequence
		@(posedge clk);
	   r <= 1'b1;
	   for (i=3; i <= 3; i = i + 1) begin
			@(posedge clk);
	   end
		r <= 1'b0;
	end
endmodule