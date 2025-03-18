`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2025 02:27:47 AM
// Design Name: 
// Module Name: MUX
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


module MUX(
    input wire signal,  // Ensure signal is wire (default for inputs)
    input wire [7:0] mux_in1,
    input wire [7:0] mux_in2,
    output reg [7:0] mux_out // Must be 'reg' since it’s assigned in always block
);

initial begin
    mux_out = 8'b0;
end
always @(*) begin
   case(signal)
       1'b0: mux_out = mux_in1;
       1'b1: mux_out = mux_in2;
   endcase
end

endmodule
