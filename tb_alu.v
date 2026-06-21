`timescale 1ns / 1ps

module alu_tb;

    parameter WIDTH = 8;

    reg [WIDTH-1:0] a, b;
    reg [3:0] opcode;
    reg enable;

    wire [WIDTH-1:0] result;
    wire zero, carry, overflow;

    // Instantiate ALU
    alu #(WIDTH) uut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .enable(enable),
        .result(result),
        .zero(zero),
        .carry(carry),
        .overflow(overflow)
    );

    initial begin

        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);

        $display("Starting ALU Test...");

        enable = 1;

        // ===============================
        // Test All Operations
        // ===============================

        a = 10; b = 5;

        opcode = 0; #10; // ADD
        opcode = 1; #10; // SUB
        opcode = 2; #10; // AND
        opcode = 3; #10; // OR
        opcode = 4; #10; // XOR
        opcode = 5; #10; // NOT
        opcode = 6; #10; // SHL
        opcode = 7; #10; // SHR
        opcode = 8; #10; // INC
        opcode = 9; #10; // DEC
        opcode = 10; #10; // COMPARE

        // ===============================
        // Edge Cases
        // ===============================

        a = 255; b = 1; opcode = 0; #10; // Overflow case
        a = 0; b = 0; opcode = 0; #10;   // Zero flag

        // ===============================
        // Invalid Opcode Check
        // ===============================

        opcode = 15; #10;
        if (opcode > 10)
            $display("Warning: Invalid opcode at time %0t", $time);

        // ===============================
        // Low Power Check
        // ===============================

        enable = 0; opcode = 0; #10;

        $display("Test Completed.");
        $finish;

    end

endmodule