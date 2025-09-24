// pc plus 4
module program_counter (
	input clk,
	input reset,
	input [31:0] PC,
	output reg [31:0] PC_plus_4
);

	always @ (posedge clk) begin
		if (reset) begin
			PC_plus_4 <= 32'd0;
		end else begin	
			PC_plus_4 <= PC + 3'd4;
		end
	end
endmodule 