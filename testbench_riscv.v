`timescale 1ns/1ns 

module testbench_riscv();
	reg clk;
	reg reset;
	
	initial clk = 0;
	always #5 clk = ~clk; // 100 MHZ 
	
	initial begin
		reset = 1;
		# 20
		reset = 0;
	end
	

	top dut (
		.clk(clk),
		.reset(reset)
	);

endmodule 