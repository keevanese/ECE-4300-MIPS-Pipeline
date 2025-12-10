module id_ex_latch(
    input        clk,
    input        rst,

    input [31:0] rd1_in,
    input [31:0] rd2_in,
    input [31:0] imm_in,
    input [4:0]  rs_in,
    input [4:0]  rt_in,
    input [4:0]  rd_in,

    input        RegDst_in,
    input        ALUSrc_in,
    input        MemtoReg_in,
    input        RegWrite_in,
    input        MemRead_in,
    input        MemWrite_in,
    input        Branch_in,
    input [1:0]  ALUOp_in,

    output reg [31:0] rd1_out,
    output reg [31:0] rd2_out,
    output reg [31:0] imm_out,
    output reg [4:0]  rs_out,
    output reg [4:0]  rt_out,
    output reg [4:0]  rd_out,

    output reg        RegDst_out,
    output reg        ALUSrc_out,
    output reg        MemtoReg_out,
    output reg        RegWrite_out,
    output reg        MemRead_out,
    output reg        MemWrite_out,
    output reg        Branch_out,
    output reg [1:0]  ALUOp_out
);
    always @(posedge clk) begin
        if (rst) begin
            rd1_out      <= 32'b0;
            rd2_out      <= 32'b0;
            imm_out      <= 32'b0;
            rs_out       <= 5'b0;
            rt_out       <= 5'b0;
            rd_out       <= 5'b0;
            RegDst_out   <= 1'b0;
            ALUSrc_out   <= 1'b0;
            MemtoReg_out <= 1'b0;
            RegWrite_out <= 1'b0;
            MemRead_out  <= 1'b0;
            MemWrite_out <= 1'b0;
            Branch_out   <= 1'b0;
            ALUOp_out    <= 2'b0;
        end else begin
            rd1_out      <= rd1_in;
            rd2_out      <= rd2_in;
            imm_out      <= imm_in;
            rs_out       <= rs_in;
            rt_out       <= rt_in;
            rd_out       <= rd_in;
            RegDst_out   <= RegDst_in;
            ALUSrc_out   <= ALUSrc_in;
            MemtoReg_out <= MemtoReg_in;
            RegWrite_out <= RegWrite_in;
            MemRead_out  <= MemRead_in;
            MemWrite_out <= MemWrite_in;
            Branch_out   <= Branch_in;
            ALUOp_out    <= ALUOp_in;
        end
    end
endmodule