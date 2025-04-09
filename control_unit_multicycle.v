module control_unit_multicycle(
    input wire clk,              // Clock input
    input wire reset,            // Reset signal
    input wire [3:0] opcode,     // Opcode as input
    output reg reg_write,        // Control signal for Register Write
    output reg branch,
    output reg ALU_src,
    output reg load,
    output reg mem_write,
    output reg jump,
    // New control signals for multi-cycle
    output reg PC_enable,        // Enable signal for program counter
    output reg IR_enable,        // Enable signal for instruction register
    // output reg ALU_enable,       // Enable signal for ALU
    output reg mem_enable,       // Enable signal for memory
    output reg reg_enable        // Enable signal for register file
);

// State definitions
localparam FETCH = 2'b00;
localparam DECODE = 2'b01;
localparam EXECUTE = 2'b10;
localparam MEMORY = 2'b11;
localparam WRITEBACK = 3'b100;  // Needs extra bit

reg [2:0] state, next_state;

// State register
always @(posedge clk or posedge reset) begin
    if (reset)
        state <= FETCH;
    else
        state <= next_state;
end

always @(posedge reset) begin
        PC_enable = 1'b1;
end

// Next state logic
always @(*) begin
    case (state)
        FETCH: next_state = DECODE;
        DECODE: next_state = EXECUTE;
        EXECUTE: begin
            if (opcode == 4'b1001 || opcode == 4'b1010)  // Load or Store
                next_state = MEMORY;
            else if (opcode < 7 || opcode == 4'b1001)    // R-type or Load needs writeback
                next_state = WRITEBACK;
            else                                        // Branch or Jump
                next_state = FETCH;
        end
        MEMORY: begin
            if (opcode == 4'b1001)                      // Load needs writeback
                next_state = WRITEBACK;
            else                                        // Store
                next_state = FETCH;
        end
        WRITEBACK: next_state = FETCH;
        default: next_state = FETCH;
    endcase
end

// Output logic
always @(*) begin
    // Default values
    reg_write = 1'b0;
    branch = 1'b0;
    ALU_src = 1'b0;
    load = 1'b0;
    mem_write = 1'b0;
    jump = 1'b0;
    PC_enable = 1'b0;
    IR_enable = 1'b0;
    // ALU_enable = 1'b0;
    mem_enable = 1'b0;
    reg_enable = 1'b0;
    
    case (state)
        FETCH: begin
            IR_enable = 1'b1;    // Enable instruction register
        end
        
        DECODE: begin
            reg_enable = 1'b1;   // Enable register file for reading
        end
        
        EXECUTE: begin
            // ALU_enable = 1'b1;   // Enable ALU
            if (opcode < 7) begin
                ALU_src = 1'b1;  // R-type
            end
            else begin
                case (opcode)
                    4'b0111, 4'b1000: begin  // BEQ, BNE
                        ALU_src = 1'b1;
                        branch = 1'b1;
                        PC_enable = 1'b1;    // Update PC for branch
                    end
                    4'b1001, 4'b1010: begin  // Load/Store
                        ALU_src = 1'b1;
                    end
                    4'b1011: begin          // Jump
                        jump = 1'b1;
                        PC_enable = 1'b1;    // Update PC for jump
                    end
                endcase
            end
        end
        
        MEMORY: begin
            mem_enable = 1'b1;   // Enable memory
            if (opcode == 4'b1001) begin  // Load
                load = 1'b1;
            end
            else if (opcode == 4'b1010) begin  // Store
                mem_write = 1'b1;
                PC_enable = 1'b1;  // Update PC after store completes
            end
        end
        
        WRITEBACK: begin
            reg_enable = 1'b1;    // Enable register file for writing
            reg_write = 1'b1;     // Enable write to register
            PC_enable = 1'b1;     // Update PC after instruction completes
        end
    endcase
end


endmodule