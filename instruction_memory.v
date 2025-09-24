// reads assembly file 

module instruction_memory (
	input [31:0] address,
	output [31:0] instruction
);

	reg [31:0] memory [0:63];
	integer i;

	/*parameter INITIAL_DATA_PATH = "../../source/imem.dat";
	
	initial
		$readmemh(INITIAL_DATA_PATH, memory);
	*/

	initial begin 
		//memory[0] = 32'b10111001110111110111_00010_0110111; // lui
		memory[0] = 32'b000000000111_00000_000_00010_0010011; // addi
		//memory[2] = 32'b000000000111_00000_000_00011_0010011; // addi
		//memory[3] = 32'b0000000_00011_00010_000_01000_1100011; // beq (branches are aligned to 2 bytes, so offset is always even, ie bit 0 is always 0)
		//memory[4] = 32'b000000000000_00000_000_00000_0010011; // addi
		//memory[5] = 32'b0000000_00000_00010_101_10000_1100011; // bge		
		//memory[1] = 32'b0000000_00010_00001_000_00011_0110011; // add
		//memory[2] = 32'b0010100_00010_00011_000_00100_0110011; // sub
		//memory[3] = 32'b0000000_00011_00001_001_00101_0110011; // sll		
		//memory[4] = 32'b111111111111_00101_100_00110_0010011;  // xori
		//memory[5] = 32'b000000010000_00001_010_00111_0010011;  // slti
		//memory[6] = 32'b0000000_00001_00000_000_00010_0100011; // sb
		//memory[7] = 32'b000000000001_010_01000_0000011; // lw
		//memory[8] = 32'b0000011_00110_00000_010_00110_0100011; // sb

	
		for (i=1; i<64; i=i+1) begin
			memory[i] = 32'h00000000;
		end
	end
	assign instruction = memory[address[31:2]];
endmodule 