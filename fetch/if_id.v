module if_id(
    input wire clk, rst,
    input wire [31:0] instr,
    input wire [31:0] npc,
    output reg [31:0] instrout,
    output reg [31:0] npcout
);
    always @(posedge clk) begin
        instrout <= instr;
        npcout <= npc;
    end
endmodule