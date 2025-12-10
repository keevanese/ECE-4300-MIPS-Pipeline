module ex_mem_latch(
    input        clk,
    input [31:0] ALUResult_in,
    input [31:0] rd2_in,
    input [4:0]  WriteReg_in,
    input        RegWrite_in,
    input        MemtoReg_in,
    input        MemRead_in,
    input        MemWrite_in,
    input        Branch_in,
    input        Zero_in,

    output reg [31:0] ALUResult_out,
    output reg [31:0] rd2_out,
    output reg [4:0]  WriteReg_out,
    output reg [1:0]  WBControl_out, // {RegWrite, MemtoReg}
    output reg        MemRead_out,
    output reg        MemWrite_out,
    output reg        Branch_out,
    output reg        Zero_out
);
    always @(posedge clk) begin
        ALUResult_out <= ALUResult_in;
        rd2_out       <= rd2_in;
        WriteReg_out  <= WriteReg_in;
        WBControl_out <= {RegWrite_in, MemtoReg_in};
        MemRead_out   <= MemRead_in;
        MemWrite_out  <= MemWrite_in;
        Branch_out    <= Branch_in;
        Zero_out      <= Zero_in;
    end
endmodule