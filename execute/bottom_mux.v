`timescale 1ns / 1ps
/*
5-bit multiplexer for selecting the destination register:
if sel == 1 -> a
if sel == 0 -> b
*/

module bottom_mux(
    output wire [4:0] y,
    input  wire [4:0] a,
    input  wire [4:0] b,
    input  wire       sel
);
    assign y = sel ? a : b;
endmodule