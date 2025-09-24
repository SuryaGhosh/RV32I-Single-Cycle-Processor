module MUX_result (
	input [31:0] ALU_result,
	input [31:0] read_data,
	input [31:0] PC_plus_4,
	//input memory_to_reg,
	input [1:0] reg_write_mode,
	output reg [31:0] result
);
	// This was necessary in order to implement J instructions
	// rd can now be written by 3 sources

 	// input [1:0] reg_write_mode
	// 0 : ALU_result
	// 1 : read_data
	// 2 : PC_plus_4
	always @ (*) begin
		case(reg_write_mode)
			0 : result = ALU_result;
			1 : result = read_data;
			2 : result = PC_plus_4;
			3 : result = ALU_result;
			default : result = 32'b0;
		endcase
	end
	//assign result = memory_to_reg ? read_data : ALU_result;
endmodule 