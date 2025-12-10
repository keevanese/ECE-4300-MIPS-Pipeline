`timescale 1ns / 1ps
/*
Tests alu.v
*/
module alu_test;

// Inputs
reg [31:0] a;
reg [31:0] b;
reg [2:0] control;

// Outputs
wire [31:0] result;
wire zero;

// Instantiate the Unit Under Test (UUT)
alu uut (
    .a(a),
    .b(b),
    .control(control),
    .result(result),
    .zero(zero)
);

// VCD DUMP FOR GTKWave
initial begin
    $dumpfile("alu_test.vcd");
    $dumpvars(0, alu_test);
end

initial begin
    a <= 'b1010;    // 10
    b <= 'b0111;    // 7
    control <= 'b011;

    $display("A = %b\t B = %b", a, b);
    $monitor("ALUop = %b\t result = %b\t zero = %b",
             control, result, zero);

    #1 control <= 'b100;
    #1 control <= 'b010;
    #1 control <= 'b111; // SLT check (result should be 0)
    #1 control <= 'b011;
    #1 control <= 'b110;
    #1 control <= 'b001; // OR  -> expect 1111
    #1 control <= 'b000; // AND -> expect 0010
    #1

    $finish;
end

endmodule
