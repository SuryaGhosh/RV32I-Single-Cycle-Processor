module register_file (
	input clk,
	input reg_write, // write enable for register in stage 3 (write back stage)
	input [4:0] A1, // source register 1
	input [4:0] A2, // source reigster 2
	input [4:0] A3, // write register
	input [31:0] WD3, // write data, comes from various places. R/I: ALUResult, load: memory, JAL/JALR: return address 
	output [31:0] RD1,	// contents of register 1 
	output [31:0] RD2	// contents of register 2
);
  
	// creates register
	reg [31:0] registers [0:31]; // the size is defined by the RISCV ISA	
	integer i;
	// initializes registers 
	initial begin
		for (i=0; i<32; i=i+1) begin
			registers[i] = 32'h0;
		end
	end


	// synchronous write 
	// on negedge since there were issues with it writing and reading simultaneously 
	always @ (negedge clk) begin 
		if (reg_write && A3!=5'b0) begin // cannot write to reg 0
			registers[A3] <= WD3;
		end
	end

	// asynchronous read
	assign RD1 = (A1 == 5'b0) ? 32'b0 : registers[A1];
	assign RD2 = (A2 == 5'b0) ? 32'b0 : registers[A2];

endmodule 
