/**
	Modulo creado para la entrada de PC + 4 a un registro.
**/

module Multiplexer_3_to_1
#(
	parameter NBits = 32
)
(
	input [1:0]Selector_i,
	input [NBits-1:0] Mux_Data_0_i,
	input [NBits-1:0] Mux_Data_1_i,
   input [NBits-1:0] Mux_Data_2_i,
	
	output reg [NBits-1:0] Mux_Output_o

);

//localparam immediate_plus_4 = 10;

	always@(Selector_i ,Mux_Data_1_i ,Mux_Data_0_i, Mux_Data_2_i) begin
		case(Selector_i)
            00:
			    Mux_Output_o = Mux_Data_0_i;
            01:
			    Mux_Output_o = Mux_Data_1_i;
            02:
             Mux_Output_o = Mux_Data_2_i;
				default:
				 Mux_Output_o = 32'b0;
      endcase
	end

endmodule