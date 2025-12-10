module instrMem(
 input [31:0] addr,
 output reg [31:0] data,
 input clk, rst
);

 reg [31:0] instrMem [0:1023];

 initial begin
 instrMem[0] = 32'hA00000AA;
 instrMem[4] = 32'h10000011;
 instrMem[8] = 32'h20000022;
 instrMem[12] = 32'h30000033;
 instrMem[16] = 32'h40000044;
 instrMem[20] = 32'h50000055;
 instrMem[24] = 32'h60000066;
 instrMem[28] = 32'h70000077;
 instrMem[32] = 32'h80000088;
 instrMem[36] = 32'h90000099;
 end

 always @(posedge clk) begin
 data <= instrMem[addr];
 end

endmodule