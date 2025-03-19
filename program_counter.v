`timescale 1ns / 1ps

module program_counter(
    input clk,
    input rst,               
    input [7:0] pc_increment, // Lower 4 bits of 8-bit input
    input jump, // Lower 4 bits of 8-bit input
    output reg [3:0] instruction_addr
    
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            instruction_addr <= 4'b0000;   // Reset counter
        else if (pc_increment[3:0] == 4'b0000)
            instruction_addr <= instruction_addr + 4'b0001;  // Increment by 1 when pc_increment is 0
        else if (jump)
            instruction_addr <= pc_increment[3:0];  // jump to address
        else
            instruction_addr <= instruction_addr + pc_increment[3:0]; // Normal increment
    end

endmodule
