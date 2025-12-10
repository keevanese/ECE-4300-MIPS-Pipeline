module fetch(

input wire clk, rst,ex_mem_pc_src,
input wire [31:0] ex_mem_npc,
output wire [31:0] if_id_instr, if_id_npc
);

//internal
wire [31:0] pc_out,
pc_plus4,
next_pc,
instr_data;

mux m0(
.y(next_pc),
.a(ex_mem_npc),
.b(pc_plus4),
.sel(ex_mem_pc_src)
);

pc pc0(
.clk(clk),
.rst(rst),
.pc_in(next_pc),
.pc_out(pc_out)
);

incrementer in0(
.pc(pc_out),
.pc_plus4(pc_plus4)
);

instrMem inMem0(
.clk(clk),
.rst(rst),
.addr(pc_out),
.data(instr_data)
);

if_id if_id0(
.clk(clk),
.rst(rst),
.instr(instr_data),
.npc(pc_plus4),
.npcout(if_id_npc),
.instrout(if_id_instr)
);


endmodule