`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2025 10:57:49 PM
// Design Name: 
// Module Name: control_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module control_unit(
    input wire [3:0] opcode,     // Opcode as input
    output reg reg_write,        // Control signal for Register Write
    output reg branch,
    output reg ALU_src,
    output reg load,
    output reg mem_write,
    output reg jump 
);

initial begin
reg_write = 1'b0;
branch = 1'b0;
ALU_src = 1'b0;
load = 1'b0;
mem_write = 1'b0;
jump = 1'b0;
end

always @(*) begin
reg_write = 1'b0;
branch = 1'b0;
ALU_src = 1'b0;
load = 1'b0;
mem_write = 1'b0;
jump = 1'b0;


if (opcode < 7) begin 
    // R-type instruction execution 
    reg_write = 1'b1;
    ALU_src = 1'b1;
end
else begin
    case (opcode)
        4'b0111: begin // branch if equal BQE
            ALU_src = 1'b1;
            branch = 1'b1;
        end
        4'b1000: begin // branch if not equal BNE
            ALU_src = 1'b1;
            branch = 1'b1;
        end
        4'b1001: begin // load instruction
            ALU_src = 1'b1;
            load = 1'b1;
            reg_write = 1'b1;
        end
        4'b1010: begin // store instruction 
            ALU_src = 1'b1;
            load = 1'b1;
            mem_write = 1'b1;
        end
        4'b1011: begin // jump
            jump = 1'b1;
        end
    endcase
end
    
    

    
end

endmodule
