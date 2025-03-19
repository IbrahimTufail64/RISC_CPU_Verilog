`timescale 1ns / 1ps

module ALU(
    input wire [7:0] data_in1,
    input wire [7:0] data_in2,
    input wire [3:0] opcode,
    input wire ALU_src,
    input wire clk,
    output reg [7:0] result,
    output reg compare
);

always @(*) begin
    compare <= 1'b0;
    if (ALU_src) begin
        case (opcode)
            4'b0000: result <= data_in1 + data_in2;   // ADD
            4'b0001: result <= data_in1 - data_in2;   // SUB
            4'b0010: result <= data_in1 & data_in2;   // AND
            4'b0011: result <= data_in1 | data_in2;   // OR
            4'b0100: result <= data_in1 ^ data_in2;   // XOR
            4'b0101: result <= data_in1 >> data_in2;   // Shift right
            4'b0110: result <= data_in1 << data_in2;   // Shift left
            4'b0111: compare <= (data_in1 == data_in2) ? 1'b1 : 1'b0; // branch if equal
            4'b1000: compare <= (data_in1 != data_in2) ? 1'b1 : 1'b0; // branch if not equal
            4'b1001: result <= data_in1 + data_in2;   // ADD for load
            4'b1010: result <= data_in1 + data_in2;   // ADD for store
            default: result <= 8'b00000000; // Default case (avoid latches)
        endcase
    end
end

endmodule
