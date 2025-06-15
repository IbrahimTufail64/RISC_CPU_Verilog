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
output reg [7:0] read_data2,
    output [7:0] r4_out,
    output [7:0] r8_out
);

reg [7:0] register_memory [15:0];
reg [7:0] register_1;
reg [7:0] register_2;
integer i;
initial begin
   
    for (i = 0; i < 16; i = i + 1)
        register_memory[i] = 16'b0000_0000_0000_0101; // Default to 5
    //let: r1 = 1,  r2 = 1, r3 = 5, r4 = 0, r5 = 5
    register_memory[1] = 16'b0000_0000_0000_0001; // r1 = 1
    register_memory[2] = 16'b0000_0000_0000_0001; // r2 = 1
    register_memory[3] = 16'b0000_0000_0000_0101; // r3 = 5
    register_memory[4] = 16'b0000_0000_0000_0101; // r4 = 5
    register_memory[5] = 16'b0000_0000_0000_0101; // r5 = 5
    //let r6 = 0, r7 = 1, r8 = 0, r9 = 0 , r10 = 0, r2 = 1, r11 = 5
    register_memory[6] = 16'b0000_0000_0000_0000; // r6 = 0
    register_memory[7] = 16'b0000_0000_0000_0001; // r7 = 1
    register_memory[8] = 16'b0000_0000_0000_0000; // r8 = 0
    register_memory[9] = 16'b0000_0000_0000_0000; // r9 = 0
    register_memory[10] = 16'b0000_0000_0000_0000; // r10 = 0
    register_memory[11] = 16'b0000_0000_0000_0100; // r11 = 4
//    register_memory[0] = 16'b0001_0000_0001_0010; 
end




// Read operation
// always @(*) begin
//     if (reg_enable) begin
//         read_data1 = register_memory[read_reg1];
//         read_data2 = register_memory[read_reg2];
//         register_1 = register_memory[read_reg1];
//         register_2 = register_memory[read_reg2];
//     end else begin
//         read_data1 = register_1;
//         read_data2 = register_2;
//     end
//     if (reg_write & reg_enable) 
//         register_memory[write_reg] <= write_data;
// end

// Combined READ/WRITE operation - combinational
always @(*) begin
    if (reg_enable) begin
        read_data1 = register_memory[read_reg1];
        read_data2 = register_memory[read_reg2];
        register_1 = register_memory[read_reg1];
        register_2 = register_memory[read_reg2];
        
        // Write operation using blocking assignment
        if (reg_write) begin
            register_memory[write_reg] = write_data;
        end
    end else begin
        read_data1 = register_1;
        read_data2 = register_2;
    end
end

assign r4_out = register_memory[4];
assign r8_out = register_memory[8];



endmodule
