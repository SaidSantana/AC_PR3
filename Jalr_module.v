module Jalr_module
#(
	parameter NBits = 32
)
(
	input Selector_i,
	input [NBits-1:0] Mux_Data_0_i,
	input [NBits-1:0] Mux_Data_1_i,
   input [12:0] Immediate_data, //Por la cantidad de bits en el inmediato de las tipo I
	
	output reg [NBits-1:0] Mux_Output_o

);

	always@(Selector_i ,Mux_Data_1_i ,Mux_Data_0_i) begin
		if(Selector_i)
			Mux_Output_o = Mux_Data_1_i + Immediate_data;
		else
			Mux_Output_o = Mux_Data_0_i;
	end

endmodule