module instruction_decoder(
    input wire [16:0] instruction,  // Instruction from Instruction Memory
    output reg [4:0] opcode,        // ALU Operation
    output reg [3:0] read_reg1,     // Source Register 1
    output reg [3:0] read_reg2,     // Source Register 2
    output reg [3:0] write_reg,     // Destination Register
    output reg [7:0] immediate      // Immediate Value
);

reg [7:0] extended_value;

always @(*) begin
    opcode    = instruction[16:12]; // Extract opcode (4 bits)
    read_reg1 = instruction[11:8];  // Extract Rs (source register 1)
    read_reg2 = instruction[7:4];   // Extract Rt (source register 2)
    
    if (opcode < 4'b0111) begin // R-type instruction
        write_reg  = instruction[3:0];   // Extract Rd (destination register)
        immediate  = 4'b0000;            // No immediate value in R-type
    end
    //for I-type instructions
    else if (instruction[16] == 1'b1) begin // Check if the instruction is I-type
        write_reg  = instruction[3:0];   // Extract Rd (destination register)
        immediate  = instruction[11:8];           
    end
    else begin
        
        extended_value = {4'b0000, instruction[3:0]}; // Zero-extend to 8 bits
        write_reg  = instruction[11:8];            // No destination register in I-type
        immediate  = extended_value;   // Extract immediate value
        
        // case (opcode)
        //             4'b0101: begin // BEQ
        //                 write_reg  = 4'b0000;            // No destination register in I-type
        //                 immediate  = extended_value;   // Extract immediate value
        //             end
        //             4'b0110: begin // LOAD
        //                 write_reg  = instruction[11:8];            // No destination register in I-type
        //                 immediate  = extended_value;   // Extract immediate value
        //             end
        //             4'b0111: begin // STORE
        //                 write_reg  = instruction[11:8];            // No destination register in I-type
        //                 immediate  = extended_value;   // Extract immediate value
        //             end
        // endcase
    end
end

endmodule
