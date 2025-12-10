`default_nettype none

module regfile(
    input  wire        clk,
    input  wire        rst,
    input  wire        regwrite,
    input  wire [4:0]  rs,
    input  wire [4:0]  rt,
    input  wire [4:0]  rd,
    input  wire [31:0] writedata,
    output reg  [31:0] A_readdat1,
    output reg  [31:0] B_readdat2,
    // debug: actual contents of register 1 ($r1)
    output reg  [31:0] r1_val
);

    // 32 registers, 32 bits each
    reg [31:0] regs [0:31];
    integer i;

    // synchronous reset + write
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end else begin
            if (regwrite && (rd != 5'd0))
                regs[rd] <= writedata;

            // hard-wire $zero to 0
            regs[0] <= 32'b0;
        end
    end

    // asynchronous read with simple bypass
    always @* begin
        // default: read from array
        A_readdat1 = (rs == 5'd0) ? 32'b0 : regs[rs];
        B_readdat2 = (rt == 5'd0) ? 32'b0 : regs[rt];

        // bypass: if we're writing and also reading same reg, show new data
        if (regwrite && (rd != 5'd0) && (rd == rs))
            A_readdat1 = writedata;

        if (regwrite && (rd != 5'd0) && (rd == rt))
            B_readdat2 = writedata;
    end

    // debug tap: track the true contents of $r1
    always @(posedge clk) begin
        if (rst)
            r1_val <= 32'b0;
        else
            r1_val <= regs[1];
    end

endmodule

`default_nettype wire
