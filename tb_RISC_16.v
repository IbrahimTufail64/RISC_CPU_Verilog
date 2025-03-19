`timescale 1ns / 1ps

module tb_RISC_16;

    // Testbench signals
    reg clk;
    reg rst;
    wire [3:0] instruction_addr;
    wire [15:0] instruction;
    
    wire [3:0] opcode;   // ALU Operation
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
    // wire [7:0] write_addr;
    // wire [7:0] read_data1;
    wire mem_write;
    wire load_signal;
    
    // Control signals
    wire reg_write;        // Control signal for Register Write
    wire ALU_src;
    wire branch;
    wire jump;
    
    wire branch_increment_signal;
    wire [7:0] pc_increment;
    
    wire [7:0] alu_result;
    wire [7:0] read_data1_mux;
    
    // Instantiate the 8-bit counter module
    program_counter uut (
        .clk(clk),
        .rst(rst),
        .instruction_addr(instruction_addr),
        .pc_increment(pc_increment),
        .jump(jump),
        .jump_label(immediate)
    );
    
    instruction_memory im(
      .addr(instruction_addr),
      .instruction(instruction)
    );
    
    instruction_decoder id(
    .opcode(opcode),
    .read_reg1(read_reg1),
    .read_reg2(read_reg2),
    .write_reg(write_reg),
    .instruction(instruction),
    .immediate(immediate)
    );
    
    control_unit cu(
    .opcode(opcode),
    .branch(branch),
    .ALU_src(ALU_src),
    .reg_write(reg_write),
    .load(load_signal),
    .mem_write(mem_write),
    .jump(jump)
    );
    
    Register_file rf(
    .read_reg1(read_reg1),
    .read_reg2(read_reg2),
    .write_reg(write_reg),
    .write_data(write_data),
    .read_data1(read_data1),
    .read_data2(read_data2),
    .reg_write(reg_write)
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
    .read_data(read_data)
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
    


    // Clock generation (10ns period -> 100MHz clock)
    always #10 clk = ~clk;

initial begin
    // Enable VCD dumping
    $dumpfile("waveform.vcd");  // Name of the output waveform file
    $dumpvars(0, tb_RISC_16);    // Dump all variables in the module
    clk = 0;
    rst = 0;  
    #10 rst = 1; // Release reset after 10ns
    #10 rst = 0;
    


    clk = 1'b0;
    // forever begin
    //   #1 clk = ~clk;
    // end

    #10
    clk = ~clk;



    #500;  // Let the simulation run for a longer time
    $finish;  // Stop simulation
end




    // Monitor changes
    initial begin
        $monitor("Time: %0t | clk: %b | rst: %b | pc_increment: %b | instruction_addr: %b", $time, clk, rst, pc_increment, instruction_addr);
    end


//always #5 clk = ~clk; // Toggle clock every 5ns (10ns period)

endmodule
