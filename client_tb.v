`define NOC_LINKS_DEST_WIDTH 4
`define NOC_LINKS_PACKETID_WIDTH 32

`define DATAW 128
`define AXIS_STRBW 8
`define AXIS_KEEPW 8
`define AXIS_IDW `NOC_LINKS_PACKETID_WIDTH
`define AXIS_DESTW `NOC_LINKS_DEST_WIDTH
`define AXIS_USERW 66
`define AXIS_MAX_DATAW 1024
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
	
	integer i;
	
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
		@(posedge clk);
	   rst <= 0;
		
		client_valid <= 1'b1;
		axis_client_interface_tready <= 1'b1;
	   for (i=1; i <= 3; i = i + 1) begin
			client_tdata <= i;
			if (i == 3) begin
				client_tlast <= 1'b1;
			end
			@(posedge clk);
	   end
 	   client_valid <= 1'b0;
	end
endmodule