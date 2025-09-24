module MUX_ALU (
	input [31:0] RD2,
	input [31:0] immExt, 
	input ALUsrc,
	output [31:0] SrcB
);

	assign SrcB = ALUsrc ? immExt : RD2;
endmodule 