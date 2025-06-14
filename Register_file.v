`timescale 1ns / 1ps


module Register_file(
input clk,
input [3:0] read_reg1,
input [3:0] read_reg2,
input [3:0] write_reg,
input [7:0] write_data,
input reg_write,
input reg_enable,
output reg [7:0] read_data1,
output reg [7:0] read_data2
);

reg [7:0] register_memory [15:0];
reg [7:0] register_1;
reg [7:0] register_2;
integer i;
initial begin
   
    for (i = 0; i < 16; i = i + 1)
        register_memory[i] = 16'b0000_0000_0000_0101; // Default to 0
//    register_memory[0] = 16'b0001_0000_0001_0010; 
end




// Read operation
always @(*) begin
    if (reg_enable) begin
        read_data1 = register_memory[read_reg1];
        read_data2 = register_memory[read_reg2];
        register_1 = register_memory[read_reg1];
        register_2 = register_memory[read_reg2];
    end else begin
        read_data1 = register_1;
        read_data2 = register_2;
    end
    if (reg_write & reg_enable) 
        register_memory[write_reg] <= write_data;
end


endmodule
