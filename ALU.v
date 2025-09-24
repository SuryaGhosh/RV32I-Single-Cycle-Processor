// performs the core integer operations, ie sub, add, shifts, branch comparisons 
// ALU_Control is derived from imem

module ALU (
	input [31:0] rs1,
	input [31:0] rs2,
	input [4:0] ALU_control,
	output reg [31:0] ALU_result,
	output reg zero // used to determine branch operations
);

	parameter ADD   = 5'd1;
	parameter SUB   = 5'd2;
	parameter XOR   = 5'd3;
	parameter OR    = 5'd4;
	parameter AND   = 5'd5;
	parameter SLL   = 5'd6;
	parameter SRL   = 5'd7;
	parameter SRA   = 5'd8;
	parameter SLT   = 5'd9;
	parameter SLTU  = 5'd10;
	parameter BEQ  = 5'd11;
	parameter BNE  = 5'd12;
	parameter BLT  = 5'd13;
	parameter BGE  = 5'd14;
	parameter BLTU = 5'd15;
	parameter BGEU = 5'd16;
	parameter JAL  = 5'd17;
	parameter LUI  = 5'd18;


	always @ (*) begin
		// we give these values meaning, we map them in the decoder 
		ALU_result = 32'b0;
		zero = 1'b0;
		case (ALU_control)
			ADD:   ALU_result = rs1 + rs2;	
			SUB:   ALU_result = rs1 - rs2; 
			XOR:   ALU_result = rs1 ^ rs2; 	
			OR:    ALU_result = rs1 | rs2; 	
			AND:   ALU_result = rs1 & rs2; 	
			SLL:   ALU_result = rs1 << rs2[4:0];
			SRL:   ALU_result = rs1 >> rs2[4:0];
			SRA:   ALU_result = rs1 >>> rs2[4:0];
			SLT:   ALU_result = (rs1 < rs2) ? 1 : 0;
			SLTU:  ALU_result = (rs1 < rs2) ? 1 : 0;	
			BEQ:   zero = (rs1 == rs2);
			BNE:   zero = (rs1 != rs2);
			BLT:   zero = (rs1 < rs2);	
			BGE:   zero = (rs1 >= rs2);
			BLTU:  zero = (rs1 < rs2);
			BGEU:  zero = (rs1 >= rs2);		
			JAL:   ALU_result = rs1 + rs2;
			LUI:   ALU_result = rs2 << 12;
		endcase
	end

endmodule 
