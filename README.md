# RISC-Inspired Multi-Cycle Processor on FPGA

## Final Year Undergraduate Project in Electrical Engineering

This project implements a RISC-inspired multi-cycle processor architecture on an FPGA platform. The design follows a step-by-step development process from individual components to a complete, functioning CPU with I/O capabilities.

## Hardware and Tools

### Hardware
- Intel Cyclone 10 FPGA (QMTECH)
- USB Blaster programmer

### Development Tools
- Xilinx Vivado for design
- Icarus Verilog for simulation
- Intel Quartus Prime for FPGA deployment

## Instruction Set Architecture

The processor implements a RISC-inspired instruction set with the following formats:

### Instruction Formats

| Format Type | Bit Fields | Description |
|-------------|------------|-------------|
| R-Type      | `[31:26]`-opcode, `[25:21]`-rs, `[20:16]`-rt, `[15:11]`-rd, `[10:6]`-shamt, `[5:0]`-funct | Register-to-register operations |
| I-Type      | `[31:26]`-opcode, `[25:21]`-rs, `[20:16]`-rt, `[15:0]`-immediate | Immediate and memory operations |
| J-Type      | `[31:26]`-opcode, `[25:0]`-address | Jump operations |

### Instruction Operations

| Instruction | Format | Mathematical Equivalent | Description |
| Instruction | Format | Opcode | Binary Format (32-bit)                  | ASM Example | Mathematical Equivalent | Description |
|-------------|--------|--------|-----------------------------------------|-------------|-------------------------|-------------|
| ADD         | R-Type | 000000 | `000000 sssss ttttt ddddd 00000 100000` | `add $rd, $rs, $rt` | Rd = Rs + Rt | Integer addition |
| SUB         | R-Type | 000000 | `000000 sssss ttttt ddddd 00000 100010` | `sub $rd, $rs, $rt` | Rd = Rs - Rt | Integer subtraction |
| AND         | R-Type | 000000 | `000000 sssss ttttt ddddd 00000 100100` | `and $rd, $rs, $rt` | Rd = Rs & Rt | Bitwise AND |
| OR          | R-Type | 000000 | `000000 sssss ttttt ddddd 00000 100101` | `or $rd, $rs, $rt` | Rd = Rs \| Rt | Bitwise OR |
| XOR         | R-Type | 000000 | `000000 sssss ttttt ddddd 00000 100110` | `xor $rd, $rs, $rt` | Rd = Rs ^ Rt | Bitwise XOR |
| SRL         | R-Type | 000000 | `000000 sssss ttttt ddddd aaaaa 000010` | `srl $rd, $rs, shamt` | Rd = Rs >> shamt | Shift right logical |
| SLL         | R-Type | 000000 | `000000 sssss ttttt ddddd aaaaa 000000` | `sll $rd, $rs, shamt` | Rd = Rs << shamt | Shift left logical |
| LW          | I-Type | 100011 | `100011 sssss ttttt iiiiiiiiiiiiiiii`   | `lw $rt, imm($rs)` | Rt = Mem[Rs + Imm] | Load word from memory |
| SW          | I-Type | 101011 | `101011 sssss ttttt iiiiiiiiiiiiiiii`   | `sw $rt, imm($rs)` | Mem[Rs + Imm] = Rt | Store word to memory |
| BEQ         | I-Type | 000100 | `000100 sssss ttttt iiiiiiiiiiiiiiii`   | `beq $rs, $rt, label` | if(Rs == Rt) PC += Imm | Branch if equal |
| BNE         | I-Type | 000101 | `000101 sssss ttttt iiiiiiiiiiiiiiii`   | `bne $rs, $rt, label` | if(Rs != Rt) PC += Imm | Branch if not equal |
| J           | J-Type | 000010 | `000010 aaaaaaaaaaaaaaaaaaaaaaaaaa`     | `j target` | PC = address | Jump to address |

## Development Phases

### Phase 1: Individual Component Design

In this phase, each functional unit of the processor was designed and tested separately.

#### ALU (Arithmetic Logic Unit)
```verilog
// ALU implements basic operations: AND, OR, ADD, SUB
// See full implementation: /src/alu.v
case(alu_control)
    4'b0000: result = a & b;    // AND
    4'b0001: result = a | b;    // OR
    4'b0010: result = a + b;    // ADD
    // ...
```

#### Instruction Memory
```verilog
// Loads instructions from program.hex file
// See full implementation: /src/instruction_memory.v
initial begin
    $readmemh("program.hex", memory);
end
```

#### Register File
```verilog
// 32x32-bit register file with synchronous write
// See full implementation: /src/register_file.v
always @(posedge clk or posedge reset) begin
    if(reset) begin
        // Reset logic
    end
    else if(reg_write && write_reg != 0)
        registers[write_reg] <= write_data;
end
```

### Phase 2: Single-Cycle Processor Design

In this phase, the individual components were integrated into a single-cycle processor with a direct control unit (no state machine).

#### Control Unit
```verilog
// Generates control signals based on opcode and function
// See full implementation: /src/control_unit.v
always @(*) begin
    case(opcode)
        6'b000000: begin // R-type
            reg_write = 1'b1;
            mem_write = 1'b0;
            // ...
        end
        // ...
    endcase
end
```

### Phase 3: Multi-Cycle Processor Implementation

In this phase, a state machine was integrated to create a multi-cycle processor, improving efficiency by breaking instruction execution into multiple stages.

#### State Machine Controller
```verilog
// Implements FETCH, DECODE, EXECUTE, MEMORY, WRITEBACK states
// See full implementation: /src/state_machine.v
always @(*) begin
    case(state)
        FETCH: next_state = DECODE;
        DECODE: next_state = EXECUTE;
        // ...
    endcase
end
```

### Phase 4: Memory-Mapped I/O and FPGA Deployment

In the final phase, memory-mapped I/O was implemented to interface with external hardware on the Cyclone 10 FPGA.

#### Memory Mapped I/O
```verilog
// Maps specific addresses to I/O devices
// See full implementation: /src/memory_with_io.v
parameter IO_SWITCHES = 32'hFFFF0000;
parameter IO_LEDS = 32'hFFFF0004;

// Memory read logic for I/O
if(address == IO_SWITCHES)
    read_data = {24'b0, switches};
```

## Conclusion

This RISC-inspired multi-cycle processor implements a basic but complete CPU architecture, including instruction fetch, decode, execute, memory access, and write-back stages. The modular approach to development allowed for systematic testing and verification at each stage. The final implementation on the Cyclone 10 FPGA demonstrates the practical application of digital design principles in creating a functioning processor.
