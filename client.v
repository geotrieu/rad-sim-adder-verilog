/* verilator lint_off BLKSEQ */
 
`define DATAW 128
 
module client (clk, rst, client_tdata, client_tlast, client_valid, axis_adder_interface_tready, client_ready, axis_adder_interface_tvalid, axis_adder_interface_tlast, axis_adder_interface_tdata);
    input clk;
    input rst;
    input [`DATAW-1:0] client_tdata;
    input client_tlast;
    input client_valid;
    input axis_adder_interface_tready;
	 
    output reg client_ready;
    output reg axis_adder_interface_tvalid;
    output reg axis_adder_interface_tlast;
    output reg [`DATAW-1:0] axis_adder_interface_tdata;

    reg client_fifo_full;
 
    always @(rst, client_fifo_full) begin
        if (rst) begin
            client_ready <= 1'b1;
        end else begin
            client_ready <= ~client_fifo_full;
        end
    end
 
    always @(posedge clk) begin
        if (rst) begin
            
        end else begin

        end
    end
endmodule
 
/* verilator lint_on BLKSEQ */