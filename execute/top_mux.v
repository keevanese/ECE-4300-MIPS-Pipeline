`timescale 1ns / 1ps
/*
32-bit multiplexer for selecting ALU's second operand:
if alusrc == 1 -> immediate (a)
if alusrc == 0 -> register value (b)
*/

module top_mux(
    output wire [31:0] y,
    input  wire [31:0] a,      // usually s_extend
    input  wire [31:0] b,      // usually rdata2
    input  wire        alusrc
);
    assign y = alusrc ? a : b;
endmodule