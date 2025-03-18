`timescale 1ns / 1ps


module instruction_memory(
input wire [3:0] addr,
output wire [15:0] instruction
);

reg [15:0] register_memory [15:0];

assign instruction = register_memory[addr];

integer i;
initial begin
   
    for (i = 0; i < 16; i = i + 1)
        register_memory[i] = 16'b0000_0000_0000_0000; // Default to 0
    register_memory[0] = 16'b0000_0000_0001_0010; 
    register_memory[1] = 16'b0001_0000_0011_0010;   
    register_memory[2] = 16'b0000_0000_0001_0100;  
    register_memory[3] = 16'b0001_0000_0001_0010;  
    register_memory[4] = 16'b0011_0100_1100_1011;  
    register_memory[5] = 16'b0101_0000_0001_0000;  
    register_memory[6] = 16'b0101_0000_0001_0010;  
    register_memory[7] = 16'b0011_0100_1100_1011;  
end





endmodule
