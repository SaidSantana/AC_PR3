module IF_ID_module
#(
	parameter NBits = 32
)
(
	input clk,
	input reset,
	input [NBits-1:0] Next_PC, //pc_w
	input [NBits-1:0] pc_plus_4_i, //pc_plus_4_w
	input [NBits-1:0] Instruction_i, //instruction_bus_w

	
	output reg [31:0] IF_ID_pc_4_o,
	output reg [31:0] IF_ID_pc_o,
	output reg [(NBits-1):0] Instruction_o
);

always@(negedge reset or posedge clk) begin
	if(reset==0) begin
		IF_ID_pc_o <= 32'h00000000;
		IF_ID_pc_4_o <= 32'h00000000;
		Instruction_o <= 32'h00000000;
	end
	else begin
		IF_ID_pc_o <= Next_PC;
		IF_ID_pc_4_o <= pc_plus_4_i;
		Instruction_o <= Instruction_i;
	end
end


endmodule