`default_nettype none
module control(
    input  wire [5:0] opcode,
    output reg        RegDst,
    output reg        ALUSrc,
    output reg        MemtoReg,
    output reg        RegWrite,
    output reg        MemRead,
    output reg        MemWrite,
    output reg        Branch,
    output reg [1:0]  ALUOp
);

    // Opcode constants
    localparam OPC_R  = 6'b000000;
    localparam OPC_LW = 6'b100011; // 0x23
    localparam OPC_SW = 6'b101011; // 0x2B
    localparam OPC_BEQ= 6'b000100; // 0x04

    always @* begin
        // defaults = NOP
        RegDst   = 0;
        ALUSrc   = 0;
        MemtoReg = 0;
        RegWrite = 0;
        MemRead  = 0;
        MemWrite = 0;
        Branch   = 0;
        ALUOp    = 2'b00;

        case (opcode)
            OPC_R: begin
                RegDst   = 1;
                ALUSrc   = 0;
                RegWrite = 1;
                ALUOp    = 2'b10;
            end

            OPC_LW: begin
                RegDst   = 0;
                ALUSrc   = 1;
                MemtoReg = 1;
                RegWrite = 1;
                MemRead  = 1;
                ALUOp    = 2'b00;
            end

            OPC_SW: begin
                ALUSrc   = 1;
                MemWrite = 1;
                ALUOp    = 2'b00;
            end

            OPC_BEQ: begin
                Branch   = 1;
                ALUSrc   = 0;
                ALUOp    = 2'b01;
            end

            default: ; // keep NOP defaults
        endcase
    end

endmodule
