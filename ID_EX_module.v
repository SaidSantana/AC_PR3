module ID_EX_module
#(
	parameter NBits = 32
)
(
	input clk,
	input reset,
	input [NBits-1:0] IF_ID_pc_4_i, //IF_ID_pc_4_o_w
	input [NBits-1:0] IF_ID_pc_i, //IF_ID_pc_o_w
	input signed [31:0] read_data_1_i, //read_data_1_w
	input [NBits-1:0] read_data_2_i, //read_data_2_w
	input [NBits-1:0] immediate_data_i,//inmmediate_data_w
	input inst_30_i,//instruction_bus_w
	input [2:0] inst_14_to_12_i,//instruction_bus_w
	input [4:0] inst_11_to_7_i,//instruction_bus_w
	input reg_write_i, //reg_write_w
	input [1:0] mem_to_reg_i, //mem_to_reg_w
	input jalr_i, //jalr_w
	input branch_i, //branch_w
	input mem_read_i, //mem_read_w
	input mem_write_i, //mem_write_w
	input [2:0] alu_op_i, //alu_op_w
	input alu_src_op_i, //alu_src_op_w

	
	output reg [31:0] ID_EX_pc_4_o,
	output reg [31:0] ID_EX_pc_o,
	output reg [4:0] ID_EX_read_1_o,
	output reg [4:0] ID_EX_read_2_o,
	output reg [31:0] ID_EX_immediate_o,
	
	output reg [2:0] ID_EX_funct3,
	output reg [4:0] ID_EX_write_register_o,
	output reg ID_EX_funct7,
	
	output reg ID_EX_reg_write_o, 
	output reg [0:1] ID_EX_mem_to_reg_o, 
	output reg ID_EX_jalr_o, 
	output reg ID_EX_branch_o, 
	output reg ID_EX_mem_read_o, 
	output reg ID_EX_mem_write_o,
	output reg [2:0] ID_EX_alu_op_o, 
	output reg ID_EX_alu_src_op_o
);

always@(negedge reset or posedge clk) begin
	if(reset==0) begin
		ID_EX_pc_4_o <= 32'h00000000;
		ID_EX_pc_o <= 32'h00000000;
		ID_EX_read_1_o <= 32'h00000000;
		ID_EX_read_2_o <= 32'h00000000;
		ID_EX_immediate_o <= 32'h00000000;
		ID_EX_funct3 <= 0;
		ID_EX_write_register_o <= 0;
		ID_EX_funct7 <= 0;
		ID_EX_reg_write_o <= 0;
		ID_EX_mem_to_reg_o <= 0;
		ID_EX_jalr_o <= 0;
		ID_EX_branch_o <= 0;
		ID_EX_mem_read_o <= 0;
		ID_EX_mem_write_o <= 0;
		ID_EX_alu_op_o <= 0;
		ID_EX_alu_src_op_o <= 0;
	end
	else begin
		ID_EX_funct3 <= inst_14_to_12_i; //Funct 3
		ID_EX_funct7 <= inst_30_i; //Funct 7
		ID_EX_write_register_o <= inst_11_to_7_i; //Write register
		ID_EX_pc_4_o <= IF_ID_pc_4_i;
		ID_EX_pc_o <= IF_ID_pc_i;
		ID_EX_read_1_o <= read_data_1_i;
		ID_EX_read_2_o <= read_data_2_i;
		ID_EX_immediate_o <= immediate_data_i;
		ID_EX_reg_write_o <= reg_write_i; 
		ID_EX_mem_to_reg_o <= mem_to_reg_i; 
		ID_EX_jalr_o <= jalr_i;
		ID_EX_branch_o <= branch_i; 
		ID_EX_mem_read_o <= mem_read_i; 
		ID_EX_mem_write_o <= mem_write_i; 
		ID_EX_alu_op_o <= alu_op_i; 
		ID_EX_alu_src_op_o <= alu_src_op_i;
	end
end


endmodule