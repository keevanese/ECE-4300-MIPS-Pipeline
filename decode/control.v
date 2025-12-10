`default_nettype none
module control(
    input clk,
    input rst,
    input [5:0] opcode,
    output reg [1:0] wb, //{RegWrite, MemToReg}
    output reg [2:0] mem, //{Branch, MemRead, MemWrite}
    output reg [3:0] ex //{RegDst, ALUOp1, ALUOp0, ALUSrc}
);

    // Opcode constants
    localparam OPC_R = 6'b000000;
    localparam OPC_LW    = 6'b100011; // 0x23
    localparam OPC_SW    = 6'b101011; // 0x2B
    localparam OPC_BEQ   = 6'b000100; // 0x04

    always @* begin
        ex = 4'b0;    //{RegDst, ALUOp1, ALUOp0, ALUSrc}
        mem = 3'b0;   //{Branch, MemRead, MemWrite}
        wb = 2'b0;    //{RegWrite, MemToReg}
 
    case (opcode)
      OPC_R: begin
            ex  = {1'b1, 1'b1, 1'b0, 1'b0}; // RegDst=1, ALUOp=10, ALUSrc=0
            mem = {1'b0, 1'b0, 1'b0};        // Branch=0, MemRead=0, MemWrite=0
            wb  = {1'b1, 1'b0};              // RegWrite=1, MemToReg=0
      end

      OPC_LW: begin
            ex  = {1'b0, 1'b0, 1'b0, 1'b1};  // RegDst=0, ALUOp=00, ALUSrc=1
            mem = {1'b0, 1'b1, 1'b0};        // MemRead=1
            wb  = {1'b1, 1'b1};              // RegWrite=1, MemToReg=1
      end

      OPC_SW: begin
            ex  = {1'b0, 1'b0, 1'b0, 1'b1};  // RegDst=X(0), ALUSrc=1, ALUOp=00
            mem = {1'b0, 1'b0, 1'b1};        // MemWrite=1
            wb  = {1'b0, 1'b0};              // RegWrite=0, MemToReg=X(0)
      end

      OPC_BEQ: begin
            ex  = {1'b0, 1'b0, 1'b1, 1'b0};  // RegDst=X(0), ALUOp=01, ALUSrc=0
            mem = {1'b1, 1'b0, 1'b0};        // Branch=1
            wb  = {1'b0, 1'b0};              // RegWrite=0
      end

      default: begin
        // remains NOP (all zeros)
      end
    endcase
  end

endmodule