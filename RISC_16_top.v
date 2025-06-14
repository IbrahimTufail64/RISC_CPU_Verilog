`timescale 1ns / 1ps

module RISC_16_top(
    input clk,
    input rst
);
    
    wire [5:0] instruction_addr;
    wire [16:0] instruction;
    
    wire [4:0] opcode;   // ALU Operation
    wire [3:0] read_reg1; // Source Register 1
    wire [3:0] read_reg2; // Source Register 2
    wire [3:0] write_reg; // Destination Register
    wire [7:0] write_data;
    wire [7:0] read_data1;
    wire [7:0] read_data2;
    wire [7:0] immediate;
    wire compare;
    
    //data memory
    wire [7:0] read_data;
    wire mem_write;
    wire load_signal;
    
    // Control signals
    wire reg_write;        // Control signal for Register Write
    wire ALU_src;
    wire branch;
    wire jump;
    wire immediate_signal;
    
    wire branch_increment_signal;
    wire [7:0] pc_increment;
    
    wire [7:0] alu_result;
    wire [7:0] read_data1_mux;
    //enable signals
    wire PC_enable;
    wire reg_enable;
    wire IR_enable;
    wire mem_enable;
    
    // Instantiate the 8-bit counter module
    program_counter uut (
        .clk(clk),
        .rst(rst),
        .instruction_addr(instruction_addr),
        .pc_increment(pc_increment),
        .jump(jump),
        .jump_label(immediate),
        .PC_enable(PC_enable)
    );
    
    instruction_memory im(
      .addr(instruction_addr),
      .instruction(instruction),
      .IR_enable(IR_enable)
    );
    
    instruction_decoder id(
    .opcode(opcode),
    .read_reg1(read_reg1),
    .read_reg2(read_reg2),
    .write_reg(write_reg),
    .instruction(instruction),
    .immediate(immediate)
    );
    
    control_unit_multicycle cu(
    .reset(rst),
    .clk(clk),
    .opcode(opcode),
    .branch(branch),
    .ALU_src(ALU_src),
    .reg_write(reg_write),
    .load(load_signal),
    .mem_write(mem_write),
    .jump(jump),
    .immediate_signal(immediate_signal),
    //enable signals 
    .PC_enable(PC_enable),
    .reg_enable(reg_enable),
    .mem_enable(mem_enable),
    .IR_enable(IR_enable)
    );
    
    Register_file rf(
    .read_reg1(read_reg1),
    .read_reg2(read_reg2),
    .write_reg(write_reg),
    .write_data(write_data),
    .read_data1(read_data1),
    .read_data2(read_data2),
    .reg_write(reg_write),
    .reg_enable(reg_enable)
    );
    
    ALU alu(
    .data_in1(read_data1_mux),
    .data_in2(read_data2),
    .opcode(opcode),
    .clk(clk),
    .result(alu_result),
    .ALU_src(ALU_src),
    .compare(compare)
    );
    
    data_memory mm(
    .read_addr(alu_result),
    .write_addr(alu_result),
    .write_data(read_data1),
    .mem_write(mem_write),
    .read_data(read_data),
    .mem_enable(mem_enable)
    );
    
    MUX memory_ALU_mux(
    .signal(load_signal),
    .mux_in2(read_data),
    .mux_in1(alu_result),
    .mux_out(write_data)
    );
    
    AND branch_ALU(
    .a(branch),
    .b(compare),
    .c(branch_increment_signal)
    );
    
     MUX alu_input_selector(
    .signal(load_signal),
    .mux_in2(immediate),
    .mux_in1(read_data1),
    .mux_out(read_data1_mux)
    );
    
    MUX branch_mux(
    .signal(branch_increment_signal),
    .mux_in2(immediate),
    .mux_in1(8'b1),
    .mux_out(pc_increment)
    );

endmodule