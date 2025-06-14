`timescale 1ns / 1ps

module tb_RISC_16;

    // Testbench signals
    reg clk;
    reg rst;
    
    // Instantiate the top module
    RISC_16_top uut (
        .clk(clk),
        .rst(rst)
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
        
        #10
        clk = ~clk;
        #10
        clk = ~clk;

        #2000;  // Let the simulation run for a longer time
        $finish;  // Stop simulation
    end

    // Monitor changes
    initial begin
        $monitor("Time: %0t | clk: %b | rst: %b | pc_increment: %b | instruction_addr: %b | PC_enable: %b | IR_enable: %b | mem_enable: %b | reg_enable: %b", 
            $time, clk, rst, uut.pc_increment, uut.instruction_addr, uut.PC_enable, uut.IR_enable, uut.mem_enable, uut.reg_enable);
    end

endmodule