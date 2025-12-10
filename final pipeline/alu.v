`timescale 1ns / 1ps
/*
ALU: performs arithmetic and logic operations based on 3-bit control.
*/

module alu(
    input  [31:0] A,
    input  [31:0] B,
    input  [3:0]  ALUCtrl,    
    output reg [31:0] Result,
    output Zero
);

always @(*) begin
    case (ALUCtrl)
        4'b0000: Result = A & B;       // AND
        4'b0001: Result = A | B;       // OR
        4'b0010: Result = A + B;       // ADD
        4'b0110: Result = A - B;       // SUB
        4'b0111: Result = (A < B);     // SLT
        4'b1100: Result = ~(A | B);    // NOR
        default: Result = 32'b0;
    endcase
end

assign Zero = (Result == 0);

endmodule
