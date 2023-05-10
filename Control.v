/******************************************************************
* Description
*	This is control unit for the RISC-V Microprocessor. The control unit is 
*	in charge of generation of the control signals. Its only input 
*	corresponds to opcode from the instruction bus.
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/
module Control
(
	input [6:0]OP_i,
	
	output Jalr_o, //nuevo output de control para el jalr únicamente
	output Branch_o,
	output Mem_Read_o,
	output [1:0]Mem_to_Reg_o,
	output Mem_Write_o,
	output ALU_Src_o,
	output Reg_Write_o,
	output [2:0]ALU_Op_o
);

//OPCODES PARA INSTRUCCIONES

localparam R_Type = 7'b0110011; // Opcode instrucciones tipo R
localparam I_Type_Logic = 7'b0010011; // Opcode instrucciones tipo I menos jalr

localparam U_Type = 7'b0110111;

localparam S_Type = 7'b0100011;

localparam I_Type_Load = 7'b0000011;

localparam B_Type = 7'b1100011;

localparam J_Type = 7'b1101111;

localparam I_Type_JALR = 7'b1100111;



reg [10:0] control_values;

always@(OP_i) begin
	case(OP_i)//                          10_9_87_6_54_3_210
		R_Type: 
			control_values= 11'b0_0_00_1_00_0_000;
		I_Type_Logic: 
			control_values= 11'b0_0_00_1_00_1_001; //Últimos 3 bits se puede asignar lo que queramos
		U_Type:
			control_values= 11'b0_0_00_1_00_1_010;
		S_Type:
			control_values= 11'b0_0_00_0_01_1_011; //3 ALU_op para tipo S
		I_Type_Load:
			control_values= 11'b0_0_01_1_10_1_100;
		B_Type: 
			control_values= 11'b0_1_00_0_00_0_101; //5 ALU_op para tipo B
		J_Type:
			control_values= 11'b0_1_10_1_00_0_110; //6 ALU_op par tipo J
		I_Type_JALR:
			control_values= 11'b1_1_10_1_10_1_111; //7 para JALR
		default:
			control_values= 11'b0_00_0_00_0_000;
		endcase
end	

assign Jalr_o = control_values[10];

assign Branch_o = control_values[9];

assign Mem_to_Reg_o = control_values[8:7]; //Ajuste para el mux 3 a 1

assign Reg_Write_o = control_values[6];

assign Mem_Read_o = control_values[5];

assign Mem_Write_o = control_values[4];

assign ALU_Src_o = control_values[3];

assign ALU_Op_o = control_values[2:0];	

endmodule


