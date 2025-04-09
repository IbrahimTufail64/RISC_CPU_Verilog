`timescale 1ns / 1ps


module data_memory(
input clk,
input [7:0] read_addr,
input [7:0] write_addr,
input [7:0] write_data,
input mem_write,
input mem_enable,
output reg [7:0] read_data
);

reg [7:0] memory [255:0];
integer i;
initial begin
   
    for (i = 0; i < 256; i = i + 1)
        memory[i] = 8'b0000_1001; // Default to 9
end

always @(*) begin
    if (mem_enable)
        if (mem_write) 
            memory[write_addr] <= write_data;
        read_data = memory[read_addr];
end



endmodule
