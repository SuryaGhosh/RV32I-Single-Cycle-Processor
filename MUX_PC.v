module MUX_PC (
	input [31:0] PC_plus_4,
	input [31:0] PC_target,
	input PC_src,
	input clk, 
	output reg [31:0] PC
);
	initial PC = 32'b0; 
	always @ (negedge clk) begin 
		PC <= PC_src ? PC_target : PC_plus_4;
	end 
endmodule 