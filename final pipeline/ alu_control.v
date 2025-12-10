`timescale 1ns / 1ps
`default_nettype none

module alu_control(
    input  wire [1:0] ALUOp,
    input  wire [5:0] funct,
    output reg  [3:0] ALUCtrl
);

    always @* begin
        case (ALUOp)
            2'b00: ALUCtrl = 4'b0010; // LW, SW
            2'b01: ALUCtrl = 4'b0110; // BEQ
            2'b10: begin              // R-type
                case (funct)
                    6'b100000: ALUCtrl = 4'b0010; // ADD
                    6'b100010: ALUCtrl = 4'b0110; // SUB
                    6'b100100: ALUCtrl = 4'b0000; // AND
                    6'b100101: ALUCtrl = 4'b0001; // OR
                    6'b101010: ALUCtrl = 4'b0111; // SLT
                    default:   ALUCtrl = 4'b0000; // safe default
                endcase
            end
            default: ALUCtrl = 4'b0000;
        endcase
    end

endmodule

`default_nettype wire
