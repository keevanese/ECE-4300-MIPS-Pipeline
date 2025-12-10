module if_id_latch(
    input wire clk, rst,
    input wire [31:0] instr_in,
    input wire [31:0] pc_in,
    output reg [31:0] instr_out,
    output reg [31:0] pc_out
);
    always @(posedge clk) begin
        instr_out <= instr_in;
        pc_out <= pc_in;
    end
endmodule