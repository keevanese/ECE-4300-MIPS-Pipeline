`timescale 1ns / 1ps
/*
Takes in 6 bit of s_extendout with alu_op and outputs select, which is the control.
for alu.v This bridges machine language with assembly language.
*/
module alu_control(
    input  wire [5:0] funct,
    input  wire [1:0] aluop,
    output reg  [2:0] select
);

    // ALU operation encodings (control to ALU)
    localparam ALU_ADD = 3'b010;
    localparam ALU_SUB = 3'b110;
    localparam ALU_AND = 3'b000;
    localparam ALU_OR  = 3'b001;
    localparam ALU_SLT = 3'b111;
    localparam ALU_XXX = 3'b011;  // unknown / don't care

    // R-type funct field encodings
    localparam FUNCT_ADD = 6'b100000;
    localparam FUNCT_SUB = 6'b100010;
    localparam FUNCT_AND = 6'b100100;
    localparam FUNCT_OR  = 6'b100101;
    localparam FUNCT_SLT = 6'b101010;

    initial select = 3'b000;

    always @* begin
        case (aluop)
            2'b00: begin
                // LW / SW: use ADD
                select = ALU_ADD;
            end
            2'b01: begin
                // BEQ: use SUB
                select = ALU_SUB;
            end
            2'b10: begin
                // R-type: decode funct field
                case (funct)
                    FUNCT_ADD: select = ALU_ADD;
                    FUNCT_SUB: select = ALU_SUB;
                    FUNCT_AND: select = ALU_AND;
                    FUNCT_OR : select = ALU_OR;
                    FUNCT_SLT: select = ALU_SLT;
                    default  : select = ALU_XXX;
                endcase
            end
            default: begin
                // unknown / invalid
                select = ALU_XXX;
            end
        endcase
    end

endmodule