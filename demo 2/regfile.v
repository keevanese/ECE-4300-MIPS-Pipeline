`default_nettype none
module regfile(
    input clk, rst, regwrite,
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] rd,
    input [31:0] writedata,
    output reg [31:0] A_readdat1,
    output reg [31:0] B_readdat2
);

    //32 registers, 32 bits each
    reg [31:0] regs [0:31];

    integer i;
    //write and reset
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i++)
                regs[i] <= 32'b0;
        end else begin
            if (regwrite && (rd != 5'd0))
                regs[rd] <= writedata;
            regs[0] <= 32'b0; // keeps $zero hard-wired
        end
    end

    //asynchronous read and write
    always @* begin
        A_readdat1 = (rs == 5'd0) ? 32'b0 : regs[rs];
        B_readdat2 = (rt == 5'd0) ? 32'b0 : regs[rt];

        if (regwrite && (rd != 5'd0) && (rd == rs)) A_readdat1 = writedata;
        if (regwrite && (rd != 5'd0) && (rd == rt)) B_readdat2 = writedata;
    end

endmodule