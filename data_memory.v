// words are determined by the computers architecture 
// in 32 bit systems, a word is 32 bits (4 bytes)
// [31:0] is 1 word = 4 bytes = 32 bits
// memory is word indexed, but the CPU gives byte addresses 
// therefore we have to divide the address by 4 to get the word 


module data_memory (
	input clk,
	input memory_write,
	input memory_read,
	input [3:0] memory_mode,
	input [31:0] address,
	input [31:0] write_data, 
	output reg [31:0] read_data
);
	// load types
	parameter BYTE = 4'd0;
	parameter HALF = 4'd1;
	parameter WORD = 4'd2;
	parameter UBYTE = 4'd3;
	parameter UHALF = 4'd4;

	// 2048 bits
	reg [31:0] memory [0:63];

	// initializes memory to 0
	integer i;
	initial begin
		for (i=0; i<64; i=i+1) begin
			memory[i] = 32'b0;
		end
	end
	
	// reads memory
	always @ (*) begin	
		if (memory_read) begin
			case (memory_mode)	
				BYTE  : read_data = {{24{memory[address][7]}}, memory[address][7:0]};   // extends MSB
				HALF  : read_data = {{16{memory[address][15]}}, memory[address][15:0]}; // extends MSB			
	 			WORD  : read_data = memory[address]; 								    // no extension needed 
				UBYTE : read_data = {24'b0, memory[address][7:0]};					    // 0 extends
				UHALF : read_data = {16'b0, memory[address][15:0]};				    	// 0 extends
				default : read_data = {memory[address][31:0]};
			endcase
		end else begin
			read_data = 32'b0;
		end
	end
	
	// writes to memory
	always @ (negedge clk) begin
		if (memory_write) begin
			case (memory_mode)
				BYTE : memory[address][7:0] <= write_data[7:0]; 
				HALF : memory[address][15:0] <= write_data[15:0]; 
				WORD : memory[address][31:0] <= write_data[31:0];
			endcase 
		end 		
	end	
endmodule 