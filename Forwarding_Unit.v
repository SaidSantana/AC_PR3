module Forwarding_Unit(
  input [4:0] EX_MEM_write_register_i,
  input [4:0] MEM_WB_write_register_i,
  input [4:0] ID_EX_read_register_1_i,
  input [4:0] ID_EX_read_register_2_i,
  
  output reg [1:0] ForwardA,
  output reg [1:0] ForwardB
);

always @* begin
  // Inicialmente, no hay forwarding disponible
  ForwardA = 0;
  ForwardB = 0;
  
  // Verificar si hay una dependencia entre la instrucción en la etapa de ejecución y la instrucción en la etapa de memoria
  if (EX_MEM_write_register_i != 0 && EX_MEM_write_register_i == ID_EX_read_register_1_i) begin
    ForwardA = 2'b10; // Seleccionar el valor de la etapa de ejecución
  end
  
  // Verificar si hay una dependencia entre la instrucción en la etapa de ejecución y la instrucción en la etapa de escritura
  else if (MEM_WB_write_register_i != 0 && MEM_WB_write_register_i == ID_EX_read_register_1_i) begin
    ForwardA = 2'b01; // Seleccionar el valor de la etapa de escritura
  end
  
  // Verificar si hay una dependencia entre la instrucción en la etapa de ejecución y la instrucción en la etapa de memoria o escritura
  if (EX_MEM_write_register_i != 0 && EX_MEM_write_register_i == ID_EX_read_register_2_i) begin
    ForwardB = 2'b10; // Seleccionar el valor de la etapa de ejecución
  end
  else if (MEM_WB_write_register_i != 0 && MEM_WB_write_register_i == ID_EX_read_register_2_i) begin
    ForwardB = 2'b01; // Seleccionar el valor de la etapa de escritura
  end
end

endmodule
