module program_counter(
    input clk,
    input rst,               // Reset input
    output reg [3:0] instruction_addr,
    input [7:0] pc_increment
);

    reg [3:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst)
            counter <= 4'b0;   // Reset counter to 0
        else
            counter <= counter + pc_increment[3:0];
        instruction_addr = counter;  // Output the current counter value
    end

    always @(*) begin
        instruction_addr = counter;  // Output the current counter value
    end

endmodule
