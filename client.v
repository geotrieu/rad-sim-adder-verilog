/* verilator lint_off BLKSEQ */
`define NOC_LINKS_DEST_WIDTH 4
`define NOC_LINKS_PACKETID_WIDTH 32

`define DATAW 128
`define AXIS_STRBW 8
`define AXIS_KEEPW 8
`define AXIS_IDW `NOC_LINKS_PACKETID_WIDTH
`define AXIS_DESTW `NOC_LINKS_DEST_WIDTH
`define AXIS_USERW 66
`define AXIS_MAX_DATAW 1024

`define DEST_ADDR `AXIS_DESTW'b11
`define SRC_ADDR `AXISUSERW'b0
 
module client (
	input clk,
	input rst,
	input [`DATAW-1:0] client_tdata,
	input client_tlast,
	input client_valid,
	input axis_client_interface_tready,
	output client_ready,
	output axis_client_interface_tvalid,
	output axis_client_interface_tlast,
	output [`AXIS_DESTW-1:0] axis_client_interface_tdest,
	output [`AXIS_IDW-1:0] axis_client_interface_tid,
	output [`AXIS_STRBW-1:0] axis_client_interface_tstrb,
	output [`AXIS_KEEPW-1:0] axis_client_interface_tkeep,
	output [`AXIS_USERW-1:0] axis_client_interface_tuser,
	output [`DATAW-1:0] axis_client_interface_tdata
);

	 reg fifo_w_en;
	 wire fifo_r_en;
	 reg [`DATAW-1:0] fifo_data_in;
	 
	 wire [`DATAW-1:0] fifo_data_out;
	 wire fifo_full;
	 wire fifo_empty;
	 
	 integer item_count;
	 
	 // there is 2 clock cycle delays from the client receiving a LAST flag to when it is 
	  
	 fifo #(.DATA_WIDTH(`DATAW), .DEPTH(8)) client_tdata_fifo(
		.clk(clk),
		.rst(rst),
		.w_enable(fifo_w_en),
		.r_enable(fifo_r_en),
		.data_in(fifo_data_in),
		.data_out(fifo_data_out),
		.full(fifo_full),
		.empty(fifo_empty)
	 );
	 
	 assign client_ready = ~fifo_full;
	 assign fifo_r_en = axis_client_interface_tvalid && axis_client_interface_tready;
	 
	 assign axis_client_interface_tdest = `DEST_ADDR;
	 assign axis_client_interface_tuser = `SRC_ADDR;
	 assign axis_client_interface_tid = {`AXIS_IDW{1'b0}};
	 assign axis_client_interface_tstrb = {`AXIS_STRBW{1'b0}};
	 assign axis_client_interface_tkeep = {`AXIS_KEEPW{1'b0}};
	 assign axis_client_interface_tvalid = ~fifo_empty;
	 assign axis_client_interface_tdata = fifo_data_out;
	 assign axis_client_interface_tlast = axis_client_interface_tvalid && item_count == 0;
 
    always @(posedge clk) begin
        if (rst) begin
            item_count <= 0;
        end else begin
				if (client_ready && client_valid) begin
					// push data onto the FIFO
					fifo_w_en <= 1;
					fifo_data_in <= client_tdata;
					item_count <= item_count + 1;
				end else begin
					fifo_w_en <= 0;
				end
				
				if (axis_client_interface_tvalid && axis_client_interface_tready) begin
					item_count <= item_count - 1;
				end
        end
    end
endmodule
 
/* verilator lint_on BLKSEQ */