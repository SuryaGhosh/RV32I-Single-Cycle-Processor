// RISCV ISA 
// https://www.cs.sfu.ca/~ashriram/Courses/CS295/assets/notebooks/RISCV/RISCV_CARD.pdf

`timescale 1ns/1ns

module control_unit (
	input [31:0] instruction,
	input zero, 
	output reg PC_src,
	//output reg memory_to_reg,
	output reg [1:0] reg_write_mode,
	output reg memory_read,
	output reg [3:0] memory_mode,
	output reg memory_write,
	output reg ALU_src,
	output reg reg_write,
	output reg [2:0] imm_src,
	output reg [4:0] ALU_control
);
	reg [6:0] op; 
	reg [2:0] funct3;
	reg [6:0] funct7;	
	reg [11:0] immediate;
	reg branch;
	reg jump;


	// default 
	parameter DEFAULT = 5'd0;

	// r type 
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

	// b type
	parameter BEQ  = 5'd11;
	parameter BNE  = 5'd12;
	parameter BLT  = 5'd13;
	parameter BGE  = 5'd14;
	parameter BLTU = 5'd15;
	parameter BGEU = 5'd16;

	// j type
	parameter JAL  = 5'd17;

	// u type
	parameter LUI  = 5'd18;

	// opcodes  
	parameter R = 7'b0110011;
	parameter I = 7'b0010011;
	parameter S = 7'b0100011;
	parameter B = 7'b1100011;
	parameter J = 7'b1101111;
	parameter U_L = 7'b0110111;
	parameter U_A = 7'b0010111;
	parameter I_L = 7'b0000011;
	parameter I_J = 7'b1100111;
	parameter I_E = 7'b1110011;

	// load memory modes
	parameter BYTE = 4'd0;
	parameter HALF = 4'd1;
	parameter WORD = 4'd2;
	parameter UBYTE = 4'd3;
	parameter UHALF = 4'd4;

	// initial values
	initial begin
		PC_src 		   = 0;
		reg_write_mode = 0;
		memory_write   = 0;
		memory_read    = 0;
		memory_mode    = 0;
		ALU_src        = 0;
		reg_write      = 0;
		branch         = 0;
		imm_src        = 0;
		PC_src		   = 0;
	end


	// controls ALU
	always @ (*) begin
		op = instruction[6:0];

		case (op) 
			R : begin 
					funct3 = instruction[14:12];
					funct7 = instruction[31:25]; 
					case ({funct3,funct7})
						10'b000_0000000 : ALU_control = ADD;
						10'b000_0010100 : ALU_control = SUB;
						10'b100_0000000 : ALU_control = XOR;
						10'b110_0000000 : ALU_control = OR;
						10'b111_0000000 : ALU_control = AND;
						10'b001_0000000 : ALU_control = SLL;
						10'b101_0000000 : ALU_control = SRL;
						10'b101_0010100 : ALU_control = SRA;
						10'b010_0000000 : ALU_control = SLT;
						10'b011_0000000 : ALU_control = SLTU;
					endcase
				end 
			I : begin 
					funct3 = instruction[14:12];  
					immediate = instruction[31:20];
					case (funct3)
						3'b000 : ALU_control = ADD;
						3'b100 : ALU_control = XOR;
						3'b110 : ALU_control = OR;
						3'b111 : ALU_control = AND;
						3'b001 : case (immediate[11:5]) 
								 	7'b0000000 : ALU_control = SLL; endcase 
						3'b101 : case (immediate[11:5]) 
								 	7'b0000000 : ALU_control = SRL;
									7'b0010100 : ALU_control = SRA; endcase
						3'b010 : ALU_control = SLT;
						3'b011 : ALU_control = SLTU;
					endcase 	
				end
			I_L : ALU_control = ADD;
			S : ALU_control = ADD;
			B : begin 
					funct3 = instruction[14:12];
					case (funct3) 
					3'b000 : ALU_control = BEQ;
					3'b001 : ALU_control = BNE;
					3'b100 : ALU_control = BLT;
					3'b101 : ALU_control = BGE;
					3'b110 : ALU_control = BLTU;
					3'b111 : ALU_control = BGEU;
				endcase
				end
			J : ALU_control = JAL;
			U_L : ALU_control = LUI;
			default : ALU_control = DEFAULT;
		endcase
	end
	

	// controls other componenets 
	always @ (*) begin
		//PC_src = 0; 

		case (op) 
			R :	begin 
					reg_write_mode <= 0;
					memory_write   <= 0;
					memory_read    <= 0;
					memory_mode    <= 0;
					ALU_src        <= 0;
					reg_write      <= 1;
					branch         <= 0;
					imm_src        <= 0;
					PC_src		   <= 0;
				end 
			I : begin  
					reg_write_mode <= 0;
					memory_write   <= 0;
					memory_read    <= 0;
					memory_mode    <= 0;
					ALU_src        <= 1; 
					reg_write      <= 1; 
					branch         <= 0;
					imm_src        <= 0;
					PC_src		   <= 0;
				end
			I_L : begin
					reg_write_mode <= 1;
					memory_write   <= 0;
					memory_read    <= 1;
					ALU_src        <= 1; 
					reg_write      <= 1; 
					branch         <= 0;
					imm_src        <= 0;
					PC_src		   <= 0;
					case (funct3)
					  	3'd0 : memory_mode <= BYTE; 
						3'd1 : memory_mode <= HALF;
						3'd2 : memory_mode <= WORD;
						3'd4 : memory_mode <= UBYTE;
						3'd5 : memory_mode <= UHALF;
						default : memory_mode <= BYTE;
					endcase
				end
			S : begin
					reg_write_mode <= 0;
					memory_write   <= 1;
					memory_read    <= 0;
					ALU_src        <= 1; 
					reg_write      <= 0; 
					branch         <= 0;
					imm_src        <= 1;
					PC_src		   <= 0;
					case (funct3)
						3'd0 : memory_mode <= BYTE; 
						3'd1 : memory_mode <= HALF;
						3'd2 : memory_mode <= WORD;
						default : memory_mode <= BYTE;
					endcase				
				end
			B : begin
					reg_write_mode <= 0;
					memory_write   <= 0;
					memory_read    <= 0;
					memory_mode    <= 0;
					ALU_src        <= 0;
					reg_write      <= 0;
					branch         <= 1;
					imm_src        <= 2;
				    PC_src		   <= 1; 
 				end
			J : begin
					reg_write_mode <= 2;
					memory_write   <= 0;
					memory_read    <= 0;
					memory_mode    <= 0;
					ALU_src        <= 0; 
					reg_write      <= 1; 
					branch         <= 0;
					imm_src        <= 4;	
					PC_src		   <= 1;
				end
			U_L : begin
					reg_write_mode <= 3;
					memory_write   <= 0;
					memory_read    <= 0;
					memory_mode    <= 0;
					ALU_src        <= 1; 
					reg_write      <= 1; 
					branch         <= 0;	
					imm_src        <= 3;	
					PC_src		   <= 0;
				end 
			default : 
				begin
					reg_write_mode <= 0;
					memory_write   <= 0;
					memory_read    <= 0;
					memory_mode    <= 0;
					ALU_src        <= 0; 
					reg_write      <= 0; 
					branch         <= 0;
					imm_src        <= 0;	
					PC_src		   <= 0;
				end 
		endcase
	end		
endmodule
