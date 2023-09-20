`include "static_params.vh"
`timescale 1ns/10ps

module client_tb;  
   reg clk, rst;
   reg [`DATAW-1:0] client_tdata;
   reg client_tlast;
	reg client_valid;
	reg axis_client_interface_tready;
	
   wire client_ready;
	wire axis_client_interface_tvalid;
	wire axis_client_interface_tlast;
	wire [`AXIS_DESTW-1:0] axis_client_interface_tdest;
	wire [`AXIS_IDW-1:0] axis_client_interface_tid;
	wire [`AXIS_STRBW-1:0] axis_client_interface_tstrb;
	wire [`AXIS_KEEPW-1:0] axis_client_interface_tkeep;
	wire [`AXIS_USERW-1:0] axis_client_interface_tuser;
	wire [`DATAW-1:0] axis_client_interface_tdata;
	
	integer i, j;
	
	client the_client(
		clk,
		rst,
		client_tdata,
		client_tlast,
		client_valid,
		axis_client_interface_tready,
		client_ready,
		axis_client_interface_tvalid,
		axis_client_interface_tlast,
		axis_client_interface_tdest,
		axis_client_interface_tid,
		axis_client_interface_tstrb,
		axis_client_interface_tkeep,
		axis_client_interface_tuser,
		axis_client_interface_tdata
	);

   initial begin
		clk = 0;
		forever #10 clk = ~clk;
   end
  
   initial begin
		rst <= 1'b1;
	   client_tlast <= 1'b0;
	   client_valid <= 1'b0;
	   client_tdata <= 0;
		axis_client_interface_tready <= 0;
		i <= 1;
		@(posedge clk);
	   rst <= 0;
		
		client_valid <= 1'b1;
	   while (i <= 20) begin
			client_tdata <= i;
			if (i == 20) begin
				client_tlast <= 1'b1;
			end
			
			@(posedge clk);
			
			if (client_valid && client_ready) begin
				i = i + 1;
			end
	   end
 	   client_valid <= 1'b0;
	end
	
	initial begin
		@(posedge clk);
		
		axis_client_interface_tready <= 1'b1;
	   for (j=1; j <= 20; j = j + 1) begin
			@(posedge clk);
			axis_client_interface_tready <= 1'b0;
			@(posedge clk);
			axis_client_interface_tready <= 1'b1;
	   end
	end
endmodule