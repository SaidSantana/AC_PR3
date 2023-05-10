module MEM_WB_module
#(
	parameter NBits = 32
)
(
	input clk,
	input reset,
	input [NBits-1:0] EX_MEM_pc_4_i, //EX_MEM_pc_4_o_w
	input [NBits-1:0] read_data_i, //rest_data_w
	input [NBits-1:0] EX_MEM_alu_result_i,//EX_MEM_alu_result_o_w
	input [4:0] EX_MEM_write_register_i,
	
	input EX_MEM_reg_write_i, 
	input [0:1] EX_MEM_mem_to_reg_i, 

	
	output reg [31:0] MEM_WB_pc_4_o,
	output reg [31:0] MEM_WB_alu_result_o,
	output reg [31:0] MEM_WB_read_data_o,
	output reg [4:0] MEM_WB_write_register_o,
	
	output reg MEM_WB_reg_write_o, 
	output reg [1:0] MEM_WB_mem_to_reg_o
);

	always@(negedge reset or posedge clk) begin
		if(reset==0)begin
			MEM_WB_pc_4_o <= 32'h00000000;
			MEM_WB_alu_result_o <= 32'h00000000;
			MEM_WB_read_data_o <= 32'h00000000;
			MEM_WB_write_register_o <= 0;
			MEM_WB_reg_write_o <= 0;
			MEM_WB_mem_to_reg_o <= 0;
		end
		else begin
			MEM_WB_pc_4_o <= EX_MEM_pc_4_i;
			MEM_WB_alu_result_o <= EX_MEM_alu_result_i;
			MEM_WB_read_data_o <= read_data_i;
			MEM_WB_reg_write_o <= EX_MEM_reg_write_i; 
			MEM_WB_mem_to_reg_o <= EX_MEM_mem_to_reg_i;
			MEM_WB_write_register_o <= EX_MEM_write_register_i;
		end
	end

endmodule