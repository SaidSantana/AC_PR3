/******************************************************************
* Description
*	This is the top-level of a RISC-V Microprocessor that can execute the next set of instructions:
*		add
*		addi
* This processor is written Verilog-HDL. It is synthesizabled into hardware.
* Parameter MEMORY_DEPTH configures the program memory to allocate the program to
* be executed. If the size of the program changes, thus, MEMORY_DEPTH must change.
* This processor was made for computer organization class at ITESO.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/

module RISC_V_Single_Cycle
#(
	parameter PROGRAM_MEMORY_DEPTH = 64,
	parameter DATA_MEMORY_DEPTH = 256
)

(
	// Inputs
	input clk,
	input reset,
	
	output [31:0] output_A,
	output [31:0] output_B

);
//******************************************************************/
//******************************************************************/

//******************************************************************/
//******************************************************************/
/* Signals to connect modules*/

/**Control**/
wire jalr_w;
wire branch_control_w;
wire alu_src_w;
wire reg_write_w;
wire [1:0]mem_to_reg_w; //Cambiando a 2 bits para selector
wire mem_write_w;
wire mem_read_w;
wire [2:0] alu_op_w;

/** Program Counter**/
wire [31:0] pc_plus_4_w;
wire [31:0] pc_w;


/**Register File**/
wire [31:0] read_data_1_w;
wire [31:0] read_data_2_w;

/**Inmmediate Unit**/
wire [31:0] inmmediate_data_w;

/**ALU**/
wire [31:0] alu_result_w;
wire zero_w;

/**Multiplexer MUX_DATA_OR_IMM_FOR_ALU**/
wire [31:0] read_data_2_or_imm_w;

/**ALU Control**/
wire [3:0] alu_operation_w;

/**Instruction Bus**/	
wire [31:0] instruction_bus_w;

/**Data Memory**/
wire [31:0] read_data_o_w;

/**Multiplexer read address or alu result w**/
wire [31:0] read_address_or_aluResult;

/**AND branch wire**/
wire [31:0] branch_w;

/**SHIFT LEFT wire**/
wire [31:0] immediate_shift_w;

/**PC plus immediate wire**/
wire [31:0] pc_plus_immediate_w;

/**New PC + 4 or PC + immediate**/
wire [31:0] pc4_or_primmediate_w;

/**New wire for the Jalr module**/
wire [31:0] jalr_output_w;

/**New wires for the IF/ID module**/
wire [31:0] IF_ID_pc_4_o_w;
wire [31:0] IF_ID_pc_o_w;
wire [31:0] IF_ID_inst_bus_o_w;

/**New wires for the ID/EX module**/
wire [31:0] ID_EX_pc_4_o_w;
wire [31:0] ID_EX_pc_o_w;
wire [31:0] ID_EX_read_1_o_w;
wire [31:0] ID_EX_read_2_o_w;
wire [31:0] ID_EX_immediate_o_w;

wire [4:0] ID_EX_write_register_w;
wire ID_EX_funct7_w;
wire [2:0] ID_EX_funct3_w;

wire ID_EX_reg_write_o_w; 
wire [1:0] ID_EX_mem_to_reg_o_w; 
wire ID_EX_jalr_o_w; 
wire ID_EX_branch_o_w;
wire ID_EX_mem_read_o_w; 
wire ID_EX_mem_write_o_w; 
wire ID_EX_alu_op_o_w; 
wire ID_EX_alu_src_op_o_w;

/**New wires for the EX/MEM module**/
wire [31:0] EX_MEM_pc_4_o_w;
wire [31:0] EX_MEM_pc_imm_o_w;
wire [31:0] EX_MEM_zero_o_w;
wire [31:0] EX_MEM_alu_result_o_w;
wire [31:0] EX_MEM_write_data_o_w;
wire [4:0] EX_MEM_write_register_o_w;

wire EX_MEM_reg_write_o_w;
wire [1:0] EX_MEM_mem_to_reg_o_w; 
wire EX_MEM_jalr_o_w; 
wire EX_MEM_branch_o_w; 
wire EX_MEM_mem_read_o_w;
wire EX_MEM_mem_write_o_w;

/**New wires for the MEM/WB module**/
wire [31:0] MEM_WB_pc_4_o_w;
wire [31:0] MEM_WB_alu_result_o_w;
wire [31:0] MEM_WB_read_data_o_w;
wire [4:0] MEM_WB_write_register_o_w;
wire MEM_WB_reg_write_o_w;
wire [1:0] MEM_WB_mem_to_reg_o_w;

//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
Control
CONTROL_UNIT
(
	/****/
	.OP_i(instruction_bus_w[6:0]),
	/** outputs**/
	.Jalr_o(jalr_w), //Signal for the JALR instruction
	.Branch_o(branch_control_w),
	//.ALU_Op_o(ID_EX_alu_op_o_w), //Modified cause of Pipes	
	.ALU_Op_o(alu_op_w),
	.ALU_Src_o(alu_src_w),
	.Reg_Write_o(reg_write_w),
	.Mem_to_Reg_o(mem_to_reg_w),
	.Mem_Read_o(mem_read_w),
	.Mem_Write_o(mem_write_w)
);



Program_Memory
#(
	.MEMORY_DEPTH(PROGRAM_MEMORY_DEPTH)
)
PROGRAM_MEMORY
(
	.Address_i(pc_w),
	.Instruction_o(instruction_bus_w)
);

//Instancia del pc register
PC_Register
#(
	.N(32)
)
PC_REGISTER
(
	.clk(clk),
	.reset(reset),
	.Next_PC(jalr_output_w),
	.PC_Value(pc_w)
);


Adder_32_Bits
PC_PLUS_4
(
	.Data0(pc_w),
	.Data1(4),
	
	.Result(pc_plus_4_w)
);


//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/



Register_File
REGISTER_FILE_UNIT
(
	.clk(clk),
	.reset(reset),
	//.Reg_Write_i(reg_write_w),
	.Reg_Write_i(MEM_WB_reg_write_o_w), //Modified cause of Pipes
	.Write_Register_i(MEM_WB_write_register_o_w),
	.Read_Register_1_i(IF_ID_inst_bus_o_w[19:15]),
	.Read_Register_2_i(IF_ID_inst_bus_o_w[24:20]),
	.Write_Data_i(read_address_or_aluResult),
	.Read_Data_1_o(read_data_1_w),
	.Read_Data_2_o(read_data_2_w)

);



Immediate_Unit
IMM_UNIT
(  .op_i(IF_ID_inst_bus_o_w[6:0]),
   .Instruction_bus_i(IF_ID_inst_bus_o_w),
   .Immediate_o(inmmediate_data_w)
);


//MUX modified cause of Pipes
Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_DATA_OR_IMM_FOR_ALU
(
	.Selector_i(ID_EX_alu_src_op_o_w),
	.Mux_Data_0_i(ID_EX_read_2_o_w),
	.Mux_Data_1_i(ID_EX_immediate_o_w),
	
	.Mux_Output_o(read_data_2_or_imm_w)
);
/*
MUX_DATA_OR_IMM_FOR_ALU
(
	.Selector_i(alu_src_w),
	.Mux_Data_0_i(read_data_2_w),
	.Mux_Data_1_i(inmmediate_data_w),
	
	.Mux_Output_o(read_data_2_or_imm_w)
);*/


ALU_Control
ALU_CONTROL_UNIT
(
	.funct7_i(ID_EX_funct7_w),
	.ALU_Op_i(ID_EX_alu_op_o_w),
	.funct3_i(ID_EX_funct3_w),
	.ALU_Operation_o(alu_operation_w)

);

//Acting as SHIFT LEFT module
assign immediate_shift_w = ID_EX_immediate_o_w << 1;

//AND for the branch
assign branch_w = EX_MEM_zero_o_w & EX_MEM_branch_o_w; //Modified cause of Pipes
//assign branch_w = zero_w & branch_control_w;

//Modified ALU cause of Pipes
ALU
ALU_UNIT
(
	.ALU_Operation_i(alu_operation_w),
	.A_i(ID_EX_read_1_o_w),
	.B_i(read_data_2_or_imm_w),
	.ALU_Result_o(alu_result_w),
	.Zero_o(zero_w)
);


//Data Memory modified cause of Pipes
Data_Memory
DATA_MEMORY_UNIT
(
	.clk(clk),
	.Mem_Write_i(EX_MEM_mem_write_o_w), 
	.Mem_Read_i(EX_MEM_mem_read_o_w),	
	.Write_Data_i(EX_MEM_write_data_o_w),
	.Address_i(EX_MEM_alu_result_o_w),
	
	
	.Read_Data_o(read_data_o_w)
);
/*DATA_MEMORY_UNIT
(
	.clk(clk),
	.Mem_Write_i(mem_write_w),
	.Mem_Read_i(mem_read_w),
	.Write_Data_i(read_data_2_w),
	.Address_i(alu_result_w),
	
	
	.Read_Data_o(read_data_o_w)
);*/

//MUX Modified cause of Pipes
Multiplexer_3_to_1
#(
	.NBits(32)
)
MUX_ALUDATA_OR_MEMORY_READ
(
	.Selector_i(MEM_WB_mem_to_reg_o_w),
	.Mux_Data_0_i(MEM_WB_alu_result_o_w),
	.Mux_Data_1_i(MEM_WB_read_data_o_w),
	.Mux_Data_2_i(MEM_WB_pc_4_o_w),
	
	.Mux_Output_o(read_address_or_aluResult)
);
/*MUX_ALUDATA_OR_MEMORY_READ
(
	.Selector_i(mem_to_reg_w),
	.Mux_Data_0_i(alu_result_w),
	.Mux_Data_1_i(read_data_o_w),
	.Mux_Data_2_i(pc_plus_4_w),
	
	.Mux_Output_o(read_address_or_aluResult)
);*/

//Adder of the PC plus immediate, for the jumps
/*Adder_32_Bits
ADDER_PC_IMMEDIATE
(
	.Data0(pc_w),
	.Data1(immediate_shift_w),
	
	.Result(pc_plus_immediate_w)
);*/
//Adder modified cause of Pipes
Adder_32_Bits
ADDER_PC_IMMEDIATE
(
	.Data0(ID_EX_pc_o_w),
	.Data1(immediate_shift_w),
	
	
	.Result(pc_plus_immediate_w)
);

/**Module used only for the JALR instruction, every other case
lets the pc4 or immediate enter**/
Jalr_module
JALR_NEW_MODULE
(
	
	//.Selector_i(jalr_w),
	.Selector_i(EX_MEM_jalr_o_w), //Modified cause of Pipes
	.Mux_Data_0_i(pc4_or_primmediate_w),
	.Mux_Data_1_i(alu_result_w),
	.Immediate_data(inmmediate_data_w),
	
	.Mux_Output_o(jalr_output_w)
);

//New module to select either pc_plus_4 or plus_immediate
//MUX modified cause of Pipes
Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_PC4_OR_PCIMMEDIATE
(
	.Selector_i(branch_w),
	.Mux_Data_0_i(pc_plus_4_w),
	.Mux_Data_1_i(EX_MEM_pc_imm_o_w),
	
	
	
	.Mux_Output_o(pc4_or_primmediate_w)
);
/*MUX_PC4_OR_PCIMMEDIATE
(
	.Selector_i(branch_w),
	.Mux_Data_0_i(pc_plus_4_w),
	.Mux_Data_1_i(pc_plus_immediate_w),
	
	
	
	.Mux_Output_o(pc4_or_primmediate_w)
);*/

//New module for First Pipe IF/ID 
IF_ID_module
#(
	.NBits(32)
)
IF_ID_NEW_MODULE
(
	.clk(clk),
	.reset(reset),
	.Next_PC(pc_w), 
	.pc_plus_4_i(pc_plus_4_w), 
	.Instruction_i(instruction_bus_w), 
	
	
	.IF_ID_pc_4_o(IF_ID_pc_4_o_w),
	.IF_ID_pc_o(IF_ID_pc_o_w),
	.Instruction_o(IF_ID_inst_bus_o_w)
);

//New module for Second Pipe ID/EX 
ID_EX_module
#(
	.NBits(32)
)
ID_EX_NEW_MODULE
(
	.clk(clk),
	.reset(reset),
	.IF_ID_pc_4_i(IF_ID_pc_4_o_w),
	.IF_ID_pc_i(IF_ID_pc_o_w),
	.read_data_1_i(read_data_1_w),
	.read_data_2_i(read_data_2_w),
	.immediate_data_i(inmmediate_data_w),
	.inst_30_i(IF_ID_inst_bus_o_w[30]),
	.inst_14_to_12_i(IF_ID_inst_bus_o_w[14:12]),
	.inst_11_to_7_i(IF_ID_inst_bus_o_w[11:7]),
	
	.reg_write_i(reg_write_w),
	.mem_to_reg_i(mem_to_reg_w),
	.jalr_i(jalr_w),
	.branch_i(branch_w),
	.mem_read_i(mem_read_w),
	.mem_write_i(mem_write_w),
	.alu_op_i(alu_op_w),
	.alu_src_op_i(alu_src_w),


	.ID_EX_pc_4_o(ID_EX_pc_4_o_w),
	.ID_EX_pc_o(ID_EX_pc_o_w),
	.ID_EX_read_1_o(ID_EX_read_1_o_w),
	.ID_EX_read_2_o(ID_EX_read_2_o_w),
	.ID_EX_immediate_o(ID_EX_immediate_o_w),
	
	//Control signals from pipe
	.ID_EX_reg_write_o(ID_EX_reg_write_o_w), 
	.ID_EX_mem_to_reg_o(ID_EX_mem_to_reg_o_w), 
	.ID_EX_jalr_o(ID_EX_jalr_o_w), 
	.ID_EX_branch_o(ID_EX_branch_o_w), 
	.ID_EX_mem_read_o(ID_EX_mem_read_o_w), 
	.ID_EX_mem_write_o(ID_EX_mem_write_o_w), 
	.ID_EX_alu_op_o(ID_EX_alu_op_o_w), 
	.ID_EX_alu_src_op_o(ID_EX_alu_src_op_o_w),
	
	.ID_EX_funct3(ID_EX_funct3_w),
	.ID_EX_write_register_o(ID_EX_write_register_w), //*
	.ID_EX_funct7(ID_EX_funct7_w)
);

//New module for Third Pipe EX/MEM 
EX_MEM_module
#(
	.NBits(32)
)
EX_MEM_NEW_MODULE
(
	.clk(clk),
	.reset(reset),
	
	//Data inputs
	.ID_EX_pc_4_i(ID_EX_pc_4_o_w),
	.pc_immediate_i(pc_plus_immediate_w),
	.zero_i(zero_w),
	.alu_result_i(alu_result_w),
	.ID_EX_read_2_i(ID_EX_read_2_o_w),
	.ID_EX_write_register_i(ID_EX_write_register_w),
	
	//Control signals inputs
	.ID_EX_reg_write_i(ID_EX_reg_write_o_w), 
	.ID_EX_mem_to_reg_i(ID_EX_mem_to_reg_o_w), 
	.ID_EX_jalr_i(ID_EX_jalr_o_w), 
	.ID_EX_branch_i(ID_EX_branch_o_w), 
	.ID_EX_mem_read_i(ID_EX_mem_read_o_w), 
	.ID_EX_mem_write_i(ID_EX_mem_write_o_w),

	//Data outputs
	.EX_MEM_pc_4_o(EX_MEM_pc_4_o_w),
	.EX_MEM_pc_o(EX_MEM_pc_imm_o_w),
	.EX_MEM_zero_o(EX_MEM_zero_o_w),
	.EX_MEM_alu_result_o(EX_MEM_alu_result_o_w),
	.EX_MEM_write_data_o(EX_MEM_write_data_o_w),
	.EX_MEM_write_register_o(EX_MEM_write_register_o_w),
	
	//Control signals outputs
	.EX_MEM_reg_write_o(EX_MEM_reg_write_o_w), 
	.EX_MEM_mem_to_reg_o(EX_MEM_mem_to_reg_o_w), 
	.EX_MEM_jalr_o(EX_MEM_jalr_o_w), 
	.EX_MEM_branch_o(EX_MEM_branch_o_w), 
	.EX_MEM_mem_read_o(EX_MEM_mem_read_o_w),
	.EX_MEM_mem_write_o(EX_MEM_mem_write_o_w)
);

//New module for Fourth Pipe MEM/WB 
MEM_WB_module
#(
	.NBits(32)
)
MEM_WB_NEW_MODULE
(
	.clk(clk),
	.reset(reset),
	
	//Data inputs
	.EX_MEM_pc_4_i(EX_MEM_pc_4_o_w),
	.read_data_i(read_data_o_w),
	.EX_MEM_write_register_i(EX_MEM_write_register_o_w),
	.EX_MEM_alu_result_i(EX_MEM_alu_result_o_w),
	
	//Control signal inputs
	.EX_MEM_reg_write_i(EX_MEM_reg_write_o_w), 
	.EX_MEM_mem_to_reg_i(EX_MEM_mem_to_reg_o_w), 
	
	//Data outputs
	.MEM_WB_pc_4_o(MEM_WB_pc_4_o_w),
	.MEM_WB_alu_result_o(MEM_WB_alu_result_o_w),
	.MEM_WB_write_register_o(MEM_WB_write_register_o_w),
	.MEM_WB_read_data_o(MEM_WB_read_data_o_w),
	
	//Control signal outputs
	.MEM_WB_reg_write_o(MEM_WB_reg_write_o_w),
	.MEM_WB_mem_to_reg_o(MEM_WB_mem_to_reg_o_w)
);

assign output_A = alu_result_w;
assign output_B = alu_result_w;


endmodule

