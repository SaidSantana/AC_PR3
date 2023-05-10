/******************************************************************
* Description
*	This is an 32-bit arithetic logic unit that can execute the next set of operations:
*		add

* This ALU is written by using behavioral description.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/

module ALU 
(
	input [3:0] ALU_Operation_i,
	input signed [31:0] A_i,
	input signed [31:0] B_i,
	output reg Zero_o,
	output reg [31:0] ALU_Result_o
);

localparam ADD = 4'b00_00;	//0 para ADD

localparam SUB = 4'b00_01; //1 para SUB

localparam OR = 4'b00_10; //2 para OR

localparam AND = 4'b00_11; //3 para AND

localparam XOR = 4'b01_00; //4 para XOR

localparam LUI = 4'b01_01; //5 para LUI

localparam SLL = 4'b01_10; //6 para SLL

localparam SRL = 4'b01_11; //7 para SRL

localparam BEQ = 4'b10_00; //8 para BEQ

localparam BNE = 4'b10_01; //9 para BNE

localparam AUIPC = 4'b11_11; //AUIPC

//localparam JAL = 4'b10_10; //10 para JAL


   always @ (A_i or B_i or ALU_Operation_i)
     begin
		case (ALU_Operation_i)
		ADD: 
			ALU_Result_o = A_i + B_i;
		SUB:
			ALU_Result_o = A_i - B_i;
		OR:
			ALU_Result_o = A_i | B_i;
		AND:
			ALU_Result_o = A_i & B_i;
		XOR:
			ALU_Result_o = A_i ^ B_i;
		LUI:
			ALU_Result_o = B_i << 12;
		SLL:
			ALU_Result_o = A_i << B_i;
		SRL:
			ALU_Result_o = A_i >> B_i;
		BEQ:
			ALU_Result_o = B_i - A_i;
		BNE:
			ALU_Result_o = (A_i == B_i);
		AUIPC:
			ALU_Result_o = A_i + (B_i << 12);
		//JAL:
			//ALU_Result_o = 0;
		default:
			ALU_Result_o = 0;
		endcase // case(control)
		
		Zero_o = (ALU_Result_o == 0) ? 1'b1 : 1'b0;
		
     end // always @ (A or B or control)
endmodule // ALU