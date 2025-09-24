// determines new address for PC jump
// PCsrc = branch 

module PC_target (
	input [31:0] PC,
	input [31:0] immediate_extension,
	output [31:0] PC_target
);

	assign PC_target = PC + immediate_extension;
endmodule 