`timescale 1ns / 1ps

module program_counter(
    input clk,
    input rst,               
    input [7:0] pc_increment, // Lower 4 bits of 8-bit input
    input jump, 
    input PC_enable,
    input [7:0] jump_label,
    output reg [5:0] instruction_addr
);

    reg first_cycle; // Flag to track the first cycle after reset

    // Initialize on reset and handle PC updates
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            instruction_addr <= 6'b000000;   // Reset counter
            first_cycle <= 1'b1;          // Set first cycle flag
        end
        else if (first_cycle || PC_enable) begin
            first_cycle <= 1'b0;          // Clear first cycle flag
            
            if (jump)
                instruction_addr <= jump_label[5:0];  // Jump to address
            else if (pc_increment[5:0] == 6'b000000)
                instruction_addr <= instruction_addr + 6'b000001;  // Increment by 1 when pc_increment is 0
            else
                instruction_addr <= instruction_addr + pc_increment[5:0]; // Increment by pc_increment
        end
        // No else case - if !PC_enable and !first_cycle, PC remains unchanged
    end

endmodule