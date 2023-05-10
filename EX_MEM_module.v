module EX_MEM_module
#(
	parameter NBits = 32
)
(	
	input clk,
	input reset,
	input [NBits-1:0] ID_EX_pc_4_i, //ID_EX_pc_4_o_W
	input [NBits-1:0] pc_immediate_i, //pc_plus_immediate_w
	input zero_i, //zero_w
	input [NBits-1:0] alu_result_i, //alu_result_w
	input [NBits-1:0] ID_EX_read_2_i,//ID_EX_read_2_o_W,
	input [4:0] ID_EX_write_register_i,
	input ID_EX_reg_write_i, 
	input [1:0] ID_EX_mem_to_reg_i, 
	input ID_EX_jalr_i, 
	input ID_EX_branch_i, 
	input ID_EX_mem_read_i, 
	input ID_EX_mem_write_i, 

	
	output reg [31:0] EX_MEM_pc_4_o,
	output reg [31:0] EX_MEM_pc_o,
	output reg 			EX_MEM_zero_o,
	output reg [31:0] EX_MEM_alu_result_o,
	output reg [31:0] EX_MEM_write_data_o,
	output reg [4:0] EX_MEM_write_register_o,
	output reg EX_MEM_reg_write_o, 
	output reg [0:1] EX_MEM_mem_to_reg_o, 
	output reg EX_MEM_jalr_o, 
	output reg EX_MEM_branch_o, 
	output reg EX_MEM_mem_read_o,
	output reg EX_MEM_mem_write_o
);

always@(negedge reset or posedge clk) begin
	if(reset==0) begin
		EX_MEM_pc_4_o<= 32'h00000000;
		EX_MEM_pc_o<= 32'h00000000;
		EX_MEM_zero_o <= 0;
		EX_MEM_alu_result_o<= 32'h00000000;
		EX_MEM_write_data_o<= 32'h00000000;
		EX_MEM_write_register_o <= 0;
		EX_MEM_reg_write_o <= 0;
		EX_MEM_mem_to_reg_o <= 0;
		EX_MEM_jalr_o <= 0;
		EX_MEM_branch_o <= 0;
		EX_MEM_mem_read_o <= 0;
		EX_MEM_mem_write_o <= 0;
	end
	else begin
		EX_MEM_pc_4_o<= ID_EX_pc_4_i;
		EX_MEM_pc_o<= pc_immediate_i;
		EX_MEM_zero_o<= zero_i;
		EX_MEM_alu_result_o<= alu_result_i;
		EX_MEM_write_data_o<= ID_EX_read_2_i;
		EX_MEM_write_register_o <= ID_EX_write_register_i;
		
		EX_MEM_reg_write_o <= ID_EX_reg_write_i; 
		EX_MEM_mem_to_reg_o <= ID_EX_mem_to_reg_i; 
		EX_MEM_jalr_o <= ID_EX_jalr_i; 
		EX_MEM_branch_o <= ID_EX_branch_i; 
		EX_MEM_mem_read_o <= ID_EX_mem_read_i;
		EX_MEM_mem_write_o <= ID_EX_mem_write_i;
	end
end


endmodule