// depending on the instruction, the register/input may not be 32 bits, we extend it to 32 bits to be used by the 32 bit ALU

module sign_extend (
	input [31:7] instruction,
	input [2:0] immediate_source,
	output reg [31:0] immediate_extension); 

	always @ (*) begin
		case (immediate_source)
			3'b000:	immediate_extension = {{20{instruction[31]}}, instruction[31:20]}; 							 				  // I type
   		    3'b001: immediate_extension = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};					      // S type
			3'b010: immediate_extension = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};   // B type
			3'b011: immediate_extension = {instruction[31:20], instruction[19:12], 12'b0}; 						                  // U type 
			3'b100: immediate_extension = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // J type
		endcase
	end
endmodule 