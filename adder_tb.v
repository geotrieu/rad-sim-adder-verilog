`define DATAW 128
`timescale 1ns/10ps

module adder_tb;

reg clk, rst;
reg axis_adder_interface_tvalid;
reg axis_adder_interface_tlast;
reg [`DATAW-1:0] axis_adder_interface_tdata;

wire axis_adder_interface_tready;

integer i;

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
	@(posedge clk);
	rst <= 0;
	
	axis_adder_interface_tvalid <= 1'b1;
	for (i=1; i <= 17; i = i + 1) begin
		axis_adder_interface_tdata <= i;
		if (i == 17) begin
			axis_adder_interface_tlast <= 1'b1;
		end
		@(posedge clk);
	end
 	axis_adder_interface_tvalid <= 1'b0;
	axis_adder_interface_tlast <= 1'b0;
end
endmodule
