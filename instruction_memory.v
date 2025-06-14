`timescale 1ns / 1ps


module instruction_memory(
input wire [3:0] addr,
output wire [15:0] instruction,
input IR_enable
);

reg [15:0] register_memory [15:0];

assign instruction = register_memory[addr];

integer i;
initial begin
   
    for (i = 0; i < 16; i = i + 1)
        register_memory[i] = 16'b0000_0000_0000_0000; // Default to 0
        //opcode_first_second_destination
        //opcode_first_second_immediate 
        //opcode_first_second_immediate 
    register_memory[1] = 16'b1010_0000_0001_0110; // STORE $r0 6($r1) : r1+6 = r0
    // register_memory[0] = 16'b0000_0000_0001_0110; // ADD
    register_memory[2] = 16'b1001_0101_0001_0110; // LOAD $r0 6($r1) : r0 = r1+6
    // register_memory[1] = 16'b0100_0000_0001_0110; // XNOR
    // register_memory[2] = 16'b0101_0000_1000_0101;  // shift right
    // register_memory[2] = 16'b0000_0110_1000_0111;  // shift right
    register_memory[3] = 16'b0110_0101_1000_0111;  // shift left
    // register_memory[4] = 16'b0111_0000_1111_0010;  // branch if equal   
    register_memory[4] = 16'b1011_0000_0000_0000;  // jump  
    register_memory[5] = 16'b0101_0000_0001_0000;  
    register_memory[6] = 16'b0000_0000_0001_0010;
    register_memory[7] = 16'b1011_0000_0000_0000; // jump to 0 instruction addr  
end





endmodule
