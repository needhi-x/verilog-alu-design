`timescale 1ns / 1ps

module alu #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire [3:0] opcode,
    input  wire enable,

    output reg  [WIDTH-1:0] result,
    output wire zero,
    output wire carry,
    output wire overflow
);

    // Internal signals
    reg [WIDTH:0] temp;   // Extra bit for carry

    // ==========================================================
    // Opcode Mapping:
    // 0000 - ADD
    // 0001 - SUB
    // 0010 - AND
    // 0011 - OR
    // 0100 - XOR
    // 0101 - NOT (A)
    // 0110 - SHIFT LEFT
    // 0111 - SHIFT RIGHT
    // 1000 - INCREMENT
    // 1001 - DECREMENT
    // 1010 - COMPARE
    // ==========================================================

    always @(*) begin
        if (enable) begin
            case (opcode)

                4'b0000: temp = a + b;          // ADD
                4'b0001: temp = a - b;          // SUB
                4'b0010: temp = a & b;          // AND
                4'b0011: temp = a | b;          // OR
                4'b0100: temp = a ^ b;          // XOR
                4'b0101: temp = ~a;             // NOT
                4'b0110: temp = a << 1;         // SHIFT LEFT
                4'b0111: temp = a >> 1;         // SHIFT RIGHT
                4'b1000: temp = a + 1;          // INCREMENT
                4'b1001: temp = a - 1;          // DECREMENT
                4'b1010: temp = (a == b) ? 1 : 0; // COMPARE

                // Safe default to avoid undefined behavior
                default: temp = 0;

            endcase
        end else begin
            // Low-power: operand isolation
            temp = 0;
        end

        result = temp[WIDTH-1:0];
    end

    // ===========================
    // FLAG GENERATION
    // ===========================

    assign zero     = (result == 0);
    assign carry    = temp[WIDTH];
    assign overflow = (opcode == 4'b0000) ? ((a[WIDTH-1] == b[WIDTH-1]) && (result[WIDTH-1] != a[WIDTH-1])) :
                      (opcode == 4'b0001) ? ((a[WIDTH-1] != b[WIDTH-1]) && (result[WIDTH-1] != a[WIDTH-1])) :
                      1'b0;

endmodule