// initializes modules 
module top (input clk, input reset);
	wire [31:0] instruction;
	wire [31:0] PC_plus_4;
	wire [31:0] PC_target;
	wire PC_src;
	wire [31:0] PC;
	wire [31:0] immediate_extension;
	wire [2:0]  immediate_source;
	wire [31:0] ALU_result;
	wire [31:0] read_data;
	wire [31:0] result;
	wire reg_write;
	wire [31:0] RD1;
	wire [31:0] RD2;
	wire [4:0] ALU_control;
	wire [31:0] SrcB;
	wire zero;
	wire memory_write;
	wire ALU_src;
	wire [3:0] memory_mode;
	wire branch;
	wire [1:0] reg_write_mode;


	instruction_memory instruction_memory_module (
		.address(PC),
		.instruction(instruction)
	);

	program_counter program_counter_module (
		.clk(clk),
		.reset(reset),
		.PC(PC),
		.PC_plus_4(PC_plus_4)
	);

	MUX_PC mux_pc_module (
		.PC_plus_4(PC_plus_4),
		.PC_target(PC_target),
		.PC_src(PC_src),
		.clk(clk),
		.PC(PC)
	);

	PC_target pc_target_module (
		.PC(PC),
		.immediate_extension(immediate_extension),
		.PC_target(PC_target)
	);
	
	sign_extend sign_extend_module (
		.instruction(instruction[31:7]),
		.immediate_source(immediate_source),
		.immediate_extension(immediate_extension)
	);

	register_file register_file_module (
		.clk(clk),
		.reg_write(reg_write), 
		.A1(instruction[19:15]), 
		.A2(instruction[24:20]), 
		.A3(instruction[11:7]),  
		.WD3(result), 
		.RD1(RD1),
		.RD2(RD2)
	);
	
	MUX_result mux_result_module (
		.ALU_result(ALU_result),
		.read_data(read_data),
		.PC_plus_4(PC_plus_4),
		.reg_write_mode(reg_write_mode),
		.result(result)
	);

	ALU ALU_module (
		.rs1(RD1),
		.rs2(SrcB),
		.ALU_control(ALU_control),
		.ALU_result(ALU_result),
		.zero(zero)
	);

	data_memory data_memory_module (
		.clk(clk),
		.memory_write(memory_write),
		.memory_read(memory_read),
		.memory_mode(memory_mode),
		.address(ALU_result),
		.write_data(RD2),
		.read_data(read_data)
	);

	MUX_ALU MUX_ALU_module (
		.RD2(RD2),
		.immExt(immediate_extension),
		.ALUsrc(ALU_src),
		.SrcB(SrcB)
	);
	
	control_unit control_unit_module (
		.instruction(instruction),
		.zero(zero),
		.PC_src(PC_src),
		.reg_write_mode(reg_write_mode),
		.memory_write(memory_write),
		.memory_read(memory_read),
		.memory_mode(memory_mode),
		.ALU_src(ALU_src),
		.reg_write(reg_write),
		.imm_src(immediate_source),
		.ALU_control(ALU_control)
	);
endmodule 