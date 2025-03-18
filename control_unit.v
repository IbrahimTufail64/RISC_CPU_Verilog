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
    output reg load
);

initial begin
reg_write = 1'b0;
branch = 1'b0;
ALU_src = 1'b0;
end
always @(*) begin
reg_write = 1'b0;
branch = 1'b0;
ALU_src = 1'b0;
load = 1'b0;

if (opcode < 5) begin 
    // R-type instruction execution 
    reg_write = 1'b1;
    ALU_src = 1'b1;
end
else begin
    case (opcode)
        4'b0101: begin // branch if equal BNE
            ALU_src = 1'b1;
            branch = 1'b1;
        end
        4'b0110: begin // load instruction
            ALU_src = 1'b1;
            load = 1'b1;
            reg_write = 1'b1;
        end
    endcase
end
    
    

    
end

endmodule
