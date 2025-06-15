`timescale 1ns / 1ps


module instruction_memory(
input wire [5:0] addr,
output wire [16:0] instruction,
input IR_enable
);

reg [16:0] register_memory [63:0];

assign instruction = register_memory[addr];

integer i;
initial begin
   
    for (i = 0; i < 64; i = i + 1)
        register_memory[i] = 16'b0000_0000_0000_0000; // Default to 0
        //opcode_first_second_destination
        //opcode_first_second_immediate 
        //opcode_first_second_immediate 


    //test program multiplication by 5
    //let: r1 = 1,  r2 = 1, r3 = 5, r4 = 5, r5 = 5
    // 1. ADD r4 r3 r4 // multiplication
    // register_memory[1] = 16'b0000_0100_0011_0100;
    // 2. ADD r1 r2 r1 // increment counter
    // register_memory[2] = 16'b0000_0001_0010_0001;
    // 3. BEQ  r1 r5 0x(5)
    // register_memory[3] = 16'b0111_0001_0101_0010;
    // 4. JUMP 0x(1)
    // register_memory[4] = 16'b1011_0000_0000_0001;
   
    // register_memory[5] = 16'b0000_0100_0000_0000;

    // test program fibbaonacci
    // ADD r6 r7 r8 // r8 = r6 + r7
    register_memory[1] = 16'b0000_0110_0111_1000;
    //ADD r7 r9 r6 // using this add instruction as MOV
    register_memory[2] = 16'b0000_0111_1001_0110;
    //ADD r8 r9 r7 // again moving r8 to r7
    register_memory[3] = 16'b0000_1000_1001_0111;
    //ADD r10 r2 r10 // incrementing r10 
    register_memory[4] = 16'b0000_1010_0010_1010;
    //BEQ r10 r11 0x2 // break the loop (skips 2 instructions)
    register_memory[5] = 16'b0111_1010_1011_0010;
    //  JUMP 0x(1)
    register_memory[6] = 16'b1011_0000_0000_0001;
    register_memory[7] = 16'b0000_1000_0000_0000;

    // register_memory[1] = 16'b1010_0000_0001_0110; // STORE $r0 6($r1) : r1+6 = r0
    // register_memory[1] = 17'b10000_0000_0001_0110; // ADD
    // register_memory[2] = 17'b0000_0110_0001_0111; // ADD
    // register_memory[2] = 17'b1001_0101_0001_0110; // LOAD $r0 6($r1) : r0 = r1+6
    // register_memory[1] = 17'b0100_0000_0001_0110; // XNOR
    // register_memory[2] = 17'b0101_0000_1000_0101;  // shift right
    // register_memory[2] = 17'b0000_0110_1000_0111;  // shift right
    // register_memory[3] = 17'b0110_0101_1000_0111;  // shift left
    // register_memory[4] = 17'b0111_0000_1111_0010;  // branch if equal   
    // register_memory[4] = 17'b1011_0000_0000_0000;  // jump  
    // register_memory[5] = 17'b0101_0000_0001_0000;  
    // register_memory[6] = 17'b0000_0000_0001_0010;
    // register_memory[7] = 17'b1011_0000_0000_0000; // jump to 0 instruction addr 
    //Loop for ever 
    register_memory[16] = 16'b1011_0000_0000_1100;
end





endmodule
