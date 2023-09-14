// Synchronous FIFO Module
// George Trieu
// Usage:
//  To write, pull w_enable HIGH and have data on the data_in bus
//  To read and pop, pull r_enable HIGH
//  To read and not pop (i.e. peek), pull r_enable LOW
// Behaviour:
//  If the FIFO is full (fifo_full == 1), any successive writes will not occur
//  If the FIFO is empty (fifo_empty == 1), any successive pops will not occur, and the read will produce a 0

module fifo #(parameter DEPTH=8, DATA_WIDTH=8) (
    input clk,
    input rst,
    input w_enable,
    input r_enable,
    input [DATA_WIDTH - 1:0] data_in,
    output reg [DATA_WIDTH - 1:0] data_out,
    output fifo_full,
    output fifo_empty,
);

reg [$clog2(DEPTH) - 1:0] r_ptr;
reg [$clog2(DEPTH) - 1:0] w_ptr;
reg [DATA_WIDTH - 1:0] fifo[0:DEPTH-1];
reg [$clog2(DEPTH) - 1:0] count;

assign fifo_full = count == DEPTH;
assign fifo_empty = count == 0;

always @(posedge clk) begin
	if (rst) begin
		r_ptr <= 0;
		w_ptr <= 0;
		count <= 0;
		data_out <= 0;
	end else begin
		if (w_enable && r_enable) begin
			if (fifo_empty) begin
				data_out <= data_in;
			end else begin
				data_out <= fifo[r_ptr];
				r_ptr <= r_ptr + 1;
				if (r_ptr == DEPTH) begin
					r_ptr <= 0;
				end
				fifo[w_ptr] <= data_in;
				w_ptr <= w_ptr + 1;
				if (w_ptr == DEPTH) begin
					w_ptr <= 0;
				end
			end
		end else if (w_enable && ~fifo_full) begin
			fifo[w_ptr] <= data_in;
			w_ptr <= w_ptr + 1;
			if (w_ptr == DEPTH) begin
				w_ptr <= 0;
			end
			count <= count + 1;
		end else if (r_enable && ~fifo_empty) begin
			data_out <= fifo[r_ptr];
			r_ptr <= r_ptr + 1;
			if (r_ptr == DEPTH) begin
				r_ptr <= 0;
			end
			count <= count - 1;
		end else if (fifo_empty) begin
			data_out <= 0;
		end else begin
			data_out <= fifo[r_ptr];
		end
	end
end

endmodule