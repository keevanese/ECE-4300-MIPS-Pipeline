module incrementer(
 input [31:0] pc,
 output reg [31:0] pc_plus4
);

 always @(*)
 pc_plus4 <= pc + 32'h00000004;
 
endmodule