`define DATAW 128
`timescale 1ns/10ps

module adder_tb;

reg clk, rst;
reg axis_adder_interface_tvalid;
reg axis_adder_interface_tlast;
reg [`DATAW-1:0] axis_adder_interface_tdata;

wire axis_adder_interface_tready;

adder my_adder(
	.clk(clk),
	.rst(rst),
	.axis_adder_interface_tvalid(axis_adder_interface_tvalid),
	.axis_adder_interface_tlast(axis_adder_interface_tlast),
	.axis_adder_interface_tdata(axis_adder_interface_tdata),
	.axis_adder_interface_tready(axis_adder_interface_tready));
 
initial
begin
	clk = 0;
	forever #10 clk = ~clk;
end

initial
begin
	rst <= 1;
	axis_adder_interface_tlast <= 1'b0;
	#15 rst <= 0;
	
	axis_adder_interface_tdata <= `DATAW'h1;
	axis_adder_interface_tvalid <= 1'b1;
	
	#20 axis_adder_interface_tdata <= `DATAW'h2;
	axis_adder_interface_tvalid <= 1'b1;
	
	#20 axis_adder_interface_tdata <= `DATAW'h3;
	axis_adder_interface_tvalid <= 1'b1;
	axis_adder_interface_tlast <= 1'b1;
end
endmodule
